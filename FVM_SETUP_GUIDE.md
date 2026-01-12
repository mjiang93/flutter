# FVM Flutter 环境配置指南

## 已完成的配置

✅ FVM (Flutter Version Management) 已安装  
✅ Flutter SDK 3.38.6 (stable) 已安装  
✅ 项目已配置使用 FVM 管理的 Flutter SDK  
✅ VSCode 配置已更新  
✅ 项目依赖已成功安装

## 常用命令

### 基本命令
```bash
# 查看 Flutter 版本
fvm flutter --version

# 运行 Flutter 命令（使用 fvm 前缀）
fvm flutter pub get
fvm flutter run
fvm flutter build

# 查看已安装的 Flutter 版本
fvm list

# 安装其他版本
fvm install 3.24.0
fvm install beta

# 切换项目使用的版本
fvm use 3.24.0
```

### 项目命令
```bash
# 获取依赖
fvm flutter pub get

# 运行代码生成
fvm flutter pub run build_runner build --delete-conflicting-outputs

# 运行应用（开发环境）
fvm flutter run --target lib/main_dev.dart

# 运行应用（生产环境）
fvm flutter run --target lib/main_prod.dart

# 运行测试
fvm flutter test
```

## IDE 配置

### VSCode
已自动配置 `.vscode/settings.json`，VSCode 会自动使用 FVM 管理的 Flutter SDK。

### Android Studio / IntelliJ IDEA
1. 打开 Settings/Preferences
2. 找到 Languages & Frameworks > Flutter
3. 设置 Flutter SDK path 为：`项目路径/.fvm/flutter_sdk`

## 环境检查

当前 Flutter Doctor 状态：
```
[✓] Flutter (Channel stable, 3.38.6)
[!] Android toolchain - 需要配置 Android SDK
[!] Xcode - 需要完整安装 Xcode
[✓] Chrome - 可用于 Web 开发
```

### 如果需要开发 Android 应用
```bash
# 接受 Android 许可
fvm flutter doctor --android-licenses
```

### 如果需要开发 iOS/macOS 应用
1. 从 App Store 安装 Xcode
2. 运行以下命令：
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

## 项目结构说明

- `.fvm/` - FVM 配置和 Flutter SDK（已在 .gitignore 中）
- `.fvm/fvm_config.json` - 项目使用的 Flutter 版本配置（应提交到 Git）
- `.vscode/settings.json` - VSCode 配置

## 团队协作

团队成员只需要：
1. 安装 FVM：`brew install fvm`
2. 克隆项目后运行：`fvm install`
3. FVM 会自动安装项目配置的 Flutter 版本

## 注意事项

- 始终使用 `fvm flutter` 而不是 `flutter` 命令
- `.fvm/fvm_config.json` 应该提交到版本控制
- `.fvm/flutter_sdk` 和 `.fvm/versions` 不应提交（已在 .gitignore）
