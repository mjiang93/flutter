# Mock 数据切换指南

## 当前状态分析

### 问题
- `lib/main.dart` 当前使用的是 `injection/mock_locator.dart`（第18行）
- `lib/injection/locator.dart` 是真实接口的配置（未被使用）
- `lib/injection/mock_locator.dart` 根据 `MockConfig` 配置决定使用 mock 还是真实接口

### 影响
- ✅ **不影响真实接口请求**：mock_locator 通过 `MockConfig` 开关控制，可以动态切换
- ✅ **架构设计合理**：使用依赖注入，切换灵活

## 快速切换方案

### 方案一：修改 MockConfig（推荐）⭐

**优点**：
- 最简单快速
- 不需要修改 import
- 支持细粒度控制（可以只 mock 部分接口）

**操作步骤**：

1. 编辑 `lib/core/configs/mock_config.dart`
2. 修改配置：

```dart
/// 使用真实接口
static const bool enableMockMode = false;

/// 或者细粒度控制
static const bool enableUserMock = false;     // 用户接口使用真实API
static const bool enableMessageMock = true;   // 消息接口使用Mock数据
```

3. 热重启应用（按 `R` 键）

### 方案二：切换 locator 文件

**优点**：
- 完全隔离 mock 代码
- 适合生产环境

**操作步骤**：

1. 编辑 `lib/main.dart` 第18行
2. 修改 import：

```dart
// 使用 Mock 数据
import 'injection/mock_locator.dart';

// 使用真实接口
import 'injection/locator.dart';
```

3. 热重启应用

### 方案三：环境变量控制（最灵活）⭐⭐

**优点**：
- 不需要修改代码
- 可以通过命令行参数控制
- 适合 CI/CD 流程

**实现步骤**：

1. 修改 `lib/core/configs/mock_config.dart`：

```dart
class MockConfig {
  MockConfig._();

  /// 从环境变量读取，默认为 true
  static final bool enableMockMode = 
      const bool.fromEnvironment('USE_MOCK', defaultValue: true);

  static const int mockNetworkDelayMs = 800;

  static final bool enableUserMock = enableMockMode;
  static final bool enableMessageMock = enableMockMode;
}
```

2. 运行命令：

```bash
# 使用 Mock 数据（默认）
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# 使用真实接口
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart --dart-define=USE_MOCK=false

# 构建时也可以控制
fvm flutter build apk --flavor dev -t lib/main_dev.dart --dart-define=USE_MOCK=false
```

## 快捷命令脚本

创建 `scripts/run_with_mock.sh`：

```bash
#!/bin/bash

# 使用 Mock 数据运行
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart --dart-define=USE_MOCK=true
```

创建 `scripts/run_with_real_api.sh`：

```bash
#!/bin/bash

# 使用真实接口运行
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart --dart-define=USE_MOCK=false
```

赋予执行权限：
```bash
chmod +x scripts/run_with_mock.sh
chmod +x scripts/run_with_real_api.sh
```

## 验证方法

### 1. 查看日志
运行后观察控制台日志：

```
# Mock 数据会显示
I/flutter: 🐛 [MockUserApiService] Fetching user info...

# 真实接口会显示
I/flutter: 🌐 [Dio] Request: GET https://dev-api.example.com/user/info
```

### 2. 检查网络请求
- Mock 数据：不会发起真实网络请求
- 真实接口：会在 Dio 日志中看到实际的 HTTP 请求

### 3. 响应时间
- Mock 数据：固定延迟 800ms
- 真实接口：取决于网络状况

## 推荐配置

### 开发阶段
```dart
static const bool enableMockMode = true;  // 使用 Mock，快速开发
```

### 联调阶段
```dart
static const bool enableUserMock = false;     // 用户接口联调
static const bool enableMessageMock = true;   // 消息接口继续 Mock
```

### 测试阶段
```dart
static const bool enableMockMode = false;  // 全部使用真实接口
```

## 注意事项

1. **热重启 vs 热重载**
   - 修改 MockConfig 后需要 **热重启**（按 `R`）
   - 热重载（按 `r`）不会重新初始化依赖注入

2. **API 地址配置**
   - 真实接口地址在 `main_dev.dart` 中配置
   - 当前配置：`https://dev-api.example.com`
   - 需要修改为实际的后端地址

3. **Mock 数据位置**
   - `lib/data/datasources/mock/mock_user_api_service.dart`
   - `lib/data/datasources/mock/mock_message_api_service.dart`

4. **生产环境**
   - 建议在 `main_prod.dart` 中强制使用 `locator.dart`
   - 或者在 MockConfig 中添加环境检查

## 当前建议

**立即可用的最简单方案**：

编辑 `lib/core/configs/mock_config.dart`，修改第8行：

```dart
static const bool enableMockMode = false;  // 改为 false 使用真实接口
```

然后热重启应用即可。
