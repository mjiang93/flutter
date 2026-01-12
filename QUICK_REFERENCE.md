# 快速参考手册

## 当前状态

- ✅ **Mock 模式**：已启用（`enableMockMode = true`）
- 📱 **运行平台**：Android 模拟器
- 🔧 **环境**：Dev
- 🎯 **影响**：Mock 不会影响真实接口，可以随时切换

## 一键切换命令

### 切换到 Mock 数据
```bash
./scripts/switch_to_mock.sh
# 然后在运行的应用中按 R 键热重启
```

### 切换到真实接口
```bash
./scripts/switch_to_real_api.sh
# 然后在运行的应用中按 R 键热重启
```

## 手动切换

编辑 `lib/core/configs/mock_config.dart` 第8行：

```dart
// 使用 Mock 数据
static const bool enableMockMode = true;

// 使用真实接口
static const bool enableMockMode = false;
```

## 验证当前模式

### 方法一：查看日志
```bash
# Mock 模式会显示
[MockUserApiService] Fetching user info...

# 真实接口会显示
[Dio] Request: GET https://dev-api.example.com/user/info
```

### 方法二：检查配置
```bash
grep "enableMockMode" lib/core/configs/mock_config.dart
```

## 运行命令

### Android
```bash
# Dev 环境（当前使用）
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# Test 环境
fvm flutter run -d emulator-5554 --flavor test -t lib/main_test.dart

# Prod 环境
fvm flutter run -d emulator-5554 --flavor prod -t lib/main_prod.dart
```

### 查看设备
```bash
fvm flutter devices
```

## 常用操作

| 操作 | 快捷键/命令 |
|------|------------|
| 热重载 | `r` |
| 热重启 | `R` |
| 停止运行 | `q` |
| 清除缓存 | `fvm flutter clean` |
| 获取依赖 | `fvm flutter pub get` |
| 代码生成 | `fvm flutter pub run build_runner build --delete-conflicting-outputs` |

## 文档索引

- 📖 **[RUN_COMMANDS.md](RUN_COMMANDS.md)** - 完整的运行命令
- 🔄 **[MOCK_SWITCH_GUIDE.md](MOCK_SWITCH_GUIDE.md)** - Mock 切换详细指南
- 📊 **[MOCK_VS_REAL_API.md](MOCK_VS_REAL_API.md)** - Mock vs 真实接口对比分析
- 📚 **[MOCK_DATA_GUIDE.md](MOCK_DATA_GUIDE.md)** - Mock 数据使用指南

## 问题排查

### 切换后没生效？
- ✅ 确认已修改 `mock_config.dart`
- ✅ 按 `R` 键热重启（不是 `r` 热重载）
- ✅ 查看日志确认当前模式

### 真实接口请求失败？
- ✅ 检查 API 地址：`lib/main_dev.dart` 中的 `apiBaseUrl`
- ✅ 当前配置：`https://dev-api.example.com`（示例地址）
- ✅ 需要修改为实际的后端地址

### Mock 数据不符合需求？
- ✅ 编辑 Mock Service：
  - 用户：`lib/data/datasources/mock/mock_user_api_service.dart`
  - 消息：`lib/data/datasources/mock/mock_message_api_service.dart`

## 快速测试

### 测试 Mock 模式
```bash
# 1. 确保使用 Mock
./scripts/switch_to_mock.sh

# 2. 启动应用
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# 3. 观察日志，应该看到 [MockXxxApiService]
```

### 测试真实接口
```bash
# 1. 切换到真实接口
./scripts/switch_to_real_api.sh

# 2. 修改 API 地址（如果需要）
vim lib/main_dev.dart  # 修改 apiBaseUrl

# 3. 启动应用
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart

# 4. 观察日志，应该看到 [Dio] Request
```

## 注意事项

⚠️ **重要**：
1. 修改 MockConfig 后必须**热重启**（按 `R`），热重载无效
2. 生产环境建议强制使用真实接口
3. Mock 数据仅用于开发和 UI 调试
4. 联调时记得切换到真实接口模式

✅ **优点**：
- Mock 和真实接口完全隔离，互不影响
- 可以随时切换，无需修改业务代码
- 支持细粒度控制（部分 Mock，部分真实）
