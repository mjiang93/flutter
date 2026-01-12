# Mock 数据 vs 真实接口对比

## 架构分析

### 当前实现方式

```
lib/main.dart
  └─> import 'injection/mock_locator.dart'
       └─> 根据 MockConfig 决定注册哪个 API Service
            ├─> MockConfig.enableUserMock = true
            │    └─> 注册 MockUserApiService（返回假数据）
            │
            └─> MockConfig.enableUserMock = false
                 └─> 注册 UserApiService（调用真实API）
```

### 依赖注入流程

```dart
// mock_locator.dart 中的关键代码
if (MockConfig.enableUserMock) {
  getIt.registerLazySingleton<UserApiService>(
    () => MockUserApiService(delayMs: MockConfig.mockNetworkDelayMs),
  );
} else {
  getIt.registerLazySingleton<UserApiService>(
    () => UserApiService(getIt<ApiClient>().dio),
  );
}
```

## 影响分析

### ✅ 不会影响真实接口的原因

1. **接口隔离**
   - `MockUserApiService` 和 `UserApiService` 都实现了相同的接口
   - Repository 层只依赖接口，不关心具体实现
   - 切换时只是替换实现类，不影响业务逻辑

2. **条件注册**
   - 通过 `if/else` 条件判断注册不同的实现
   - Mock 和真实 API 不会同时存在
   - 运行时只有一个实现被注册到容器中

3. **Mock 实现独立**
   - Mock 类不会修改或拦截真实的网络请求
   - Mock 数据完全在内存中生成
   - 不依赖 Dio 或任何网络库

### 对比表格

| 特性 | Mock 数据模式 | 真实接口模式 |
|------|--------------|-------------|
| **网络请求** | ❌ 不发起 | ✅ 发起真实请求 |
| **响应时间** | 固定 800ms | 取决于网络 |
| **数据来源** | 代码中硬编码 | 后端 API |
| **需要后端** | ❌ 不需要 | ✅ 需要 |
| **离线开发** | ✅ 支持 | ❌ 不支持 |
| **数据真实性** | ❌ 假数据 | ✅ 真实数据 |
| **调试难度** | 简单 | 复杂 |
| **适用场景** | 前端开发、UI调试 | 联调、测试 |

## 切换方法对比

### 方法一：修改 MockConfig（最简单）⭐⭐⭐

```bash
# 1. 编辑文件
vim lib/core/configs/mock_config.dart

# 2. 修改配置
static const bool enableMockMode = false;  // true=Mock, false=真实

# 3. 热重启应用（按 R 键）
```

**优点**：
- ✅ 最快速，只需改一行代码
- ✅ 支持细粒度控制（可以只 mock 部分接口）
- ✅ 不需要修改 import

**缺点**：
- ❌ 需要手动编辑文件
- ❌ 容易忘记改回来

### 方法二：使用脚本（推荐）⭐⭐⭐⭐

```bash
# 切换到 Mock
./scripts/switch_to_mock.sh

# 切换到真实接口
./scripts/switch_to_real_api.sh

# 然后热重启应用（按 R 键）
```

**优点**：
- ✅ 一键切换，不易出错
- ✅ 有提示信息
- ✅ 可以加入版本控制

**缺点**：
- ❌ 仍需要热重启

### 方法三：环境变量（最灵活）⭐⭐⭐⭐⭐

**第一步：修改 MockConfig**

```dart
// lib/core/configs/mock_config.dart
class MockConfig {
  MockConfig._();

  // 从环境变量读取
  static final bool enableMockMode = 
      const bool.fromEnvironment('USE_MOCK', defaultValue: true);

  static const int mockNetworkDelayMs = 800;
  static final bool enableUserMock = enableMockMode;
  static final bool enableMessageMock = enableMockMode;
}
```

**第二步：运行命令**

```bash
# 使用 Mock（默认）
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# 使用真实接口
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart \
  --dart-define=USE_MOCK=false

# 或者创建别名
alias run-mock='fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart'
alias run-real='fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart --dart-define=USE_MOCK=false'
```

**优点**：
- ✅ 不需要修改代码
- ✅ 不需要热重启，直接启动就是对应模式
- ✅ 适合 CI/CD 流程
- ✅ 可以通过命令行参数控制

**缺点**：
- ❌ 需要先修改 MockConfig 实现
- ❌ 命令行参数较长

## 验证方法

### 1. 查看启动日志

**Mock 模式**：
```
I/flutter: 🐛 [MockUserApiService] Fetching user info...
I/flutter: 🐛 [MockMessageApiService] Fetching messages...
```

**真实接口模式**：
```
I/flutter: 🌐 [Dio] Request: GET https://dev-api.example.com/user/info
I/flutter: 🌐 [Dio] Response: 200 OK
```

### 2. 检查响应时间

**Mock 模式**：
- 固定延迟 800ms
- 不受网络影响

**真实接口模式**：
- 响应时间不固定
- 受网络状况影响

### 3. 检查数据内容

**Mock 模式**：
```json
{
  "id": "user123",
  "nickname": "John Doe",
  "phone": "13800138000",
  "avatar": "https://via.placeholder.com/150"
}
```

**真实接口模式**：
- 返回后端实际数据
- 数据会变化

## 推荐工作流程

### 阶段一：UI 开发（使用 Mock）

```bash
# 1. 确保使用 Mock
./scripts/switch_to_mock.sh

# 2. 启动应用
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# 3. 专注于 UI 开发，不依赖后端
```

### 阶段二：接口联调（逐步切换）

```dart
// lib/core/configs/mock_config.dart
static const bool enableUserMock = false;     // 用户接口已联调
static const bool enableMessageMock = true;   // 消息接口继续 Mock
```

### 阶段三：集成测试（使用真实接口）

```bash
# 1. 切换到真实接口
./scripts/switch_to_real_api.sh

# 2. 启动应用
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# 3. 进行完整的功能测试
```

## 常见问题

### Q1: 切换后没有生效？

**A**: 需要热重启（按 `R` 键），热重载（按 `r`）不会重新初始化依赖注入。

### Q2: 如何确认当前使用的是哪种模式？

**A**: 查看日志：
- 看到 `[MockXxxApiService]` = Mock 模式
- 看到 `[Dio] Request` = 真实接口模式

### Q3: 可以部分接口用 Mock，部分用真实接口吗？

**A**: 可以！修改 MockConfig：

```dart
static const bool enableUserMock = false;     // 真实接口
static const bool enableMessageMock = true;   // Mock 数据
```

### Q4: 生产环境会不会误用 Mock 数据？

**A**: 建议在 `main_prod.dart` 中强制使用真实接口：

```dart
// main_prod.dart
import 'injection/locator.dart';  // 强制使用真实接口
```

或者在 MockConfig 中添加环境检查：

```dart
static final bool enableMockMode = 
    FlavorConfig.instance.flavor != Flavor.prod;  // 生产环境强制关闭
```

### Q5: Mock 数据如何修改？

**A**: 编辑对应的 Mock Service：
- 用户数据：`lib/data/datasources/mock/mock_user_api_service.dart`
- 消息数据：`lib/data/datasources/mock/mock_message_api_service.dart`

## 总结

### ✅ 当前实现的优点

1. **架构清晰**：通过依赖注入实现 Mock 和真实接口的无缝切换
2. **互不影响**：Mock 和真实接口完全隔离，不会相互干扰
3. **灵活可控**：支持全局切换和细粒度控制
4. **开发友好**：前端可以独立开发，不依赖后端进度

### 🎯 推荐方案

**日常开发**：使用脚本快速切换
```bash
./scripts/switch_to_mock.sh      # 开发 UI
./scripts/switch_to_real_api.sh  # 联调测试
```

**CI/CD 流程**：使用环境变量控制
```bash
flutter test --dart-define=USE_MOCK=true   # 单元测试用 Mock
flutter test --dart-define=USE_MOCK=false  # 集成测试用真实接口
```

### 📝 下一步建议

1. ✅ 当前 Mock 实现已经很完善，不需要修改
2. 🔧 如果需要更灵活的控制，可以实现环境变量方案
3. 📚 建议在团队中统一切换方法，避免混乱
