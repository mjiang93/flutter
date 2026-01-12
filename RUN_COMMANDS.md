# 项目运行命令

## Android 模拟器运行

### Dev 环境
```bash
fvm flutter run -d emulator-5554 --flavor dev -t lib/main_dev.dart
```

### Test 环境
```bash
fvm flutter run -d emulator-5554 --flavor test -t lib/main_test.dart
```

### Prod 环境
```bash
fvm flutter run -d emulator-5554 --flavor prod -t lib/main_prod.dart
```

## iOS 模拟器运行

### Dev 环境
```bash
fvm flutter run -d <ios-simulator-id> --flavor dev -t lib/main_dev.dart
```

### Test 环境
```bash
fvm flutter run -d <ios-simulator-id> --flavor test -t lib/main_test.dart
```

### Prod 环境
```bash
fvm flutter run -d <ios-simulator-id> --flavor prod -t lib/main_prod.dart
```

## 查看可用设备
```bash
fvm flutter devices
```

## 构建 APK

### Dev 环境
```bash
fvm flutter build apk --flavor dev -t lib/main_dev.dart
```

### Test 环境
```bash
fvm flutter build apk --flavor test -t lib/main_test.dart
```

### Prod 环境（带混淆）
```bash
fvm flutter build apk --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/app/outputs/symbols
```

## 构建 iOS

### Dev 环境
```bash
fvm flutter build ios --flavor dev -t lib/main_dev.dart
```

### Test 环境
```bash
fvm flutter build ios --flavor test -t lib/main_test.dart
```

### Prod 环境（带混淆）
```bash
fvm flutter build ios --release --flavor prod -t lib/main_prod.dart --obfuscate --split-debug-info=build/ios/outputs/symbols
```

## Mock 数据切换

### 快速切换脚本

```bash
# 切换到 Mock 数据模式
./scripts/switch_to_mock.sh

# 切换到真实接口模式
./scripts/switch_to_real_api.sh

# 切换后需要热重启应用（按 R 键）
```

### 手动切换

编辑 `lib/core/configs/mock_config.dart`：

```dart
// 使用 Mock 数据
static const bool enableMockMode = true;

// 使用真实接口
static const bool enableMockMode = false;
```

### 验证当前模式

```bash
# 查看配置
grep "enableMockMode" lib/core/configs/mock_config.dart

# 查看运行日志
# Mock 模式：[MockUserApiService] Fetching user info...
# 真实接口：[Dio] Request: GET https://dev-api.example.com/user/info
```

详细说明请查看：
- [MOCK_SWITCH_GUIDE.md](MOCK_SWITCH_GUIDE.md) - 切换指南
- [MOCK_VS_REAL_API.md](MOCK_VS_REAL_API.md) - 对比分析
- [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - 快速参考

## 注意事项

1. 确保已安装 FVM 并配置好 Flutter 版本
2. Android 模拟器需要先启动
3. iOS 需要在 macOS 上运行，并安装 Xcode
4. 首次运行需要先执行 `fvm flutter pub get` 安装依赖
5. 如果修改了代码生成相关文件，需要运行 `fvm flutter pub run build_runner build --delete-conflicting-outputs`
6. **切换 Mock/真实接口后需要热重启（按 R 键），热重载无效**
7. 当前默认使用 Mock 数据，真实接口地址为示例地址，需要修改 `lib/main_dev.dart` 中的 `apiBaseUrl`
