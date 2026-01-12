# Mock 数据使用指南

## 概述

项目现已集成 Mock 数据支持，允许在没有真实后端接口的情况下进行开发和测试。Mock 数据会模拟真实的网络延迟，帮助测试加载状态和动画效果。

## 快速开始

### 启用 Mock 模式

编辑 `lib/core/configs/mock_config.dart`：

```dart
class MockConfig {
  // 设置为 true 启用 Mock 模式
  static const bool enableMockMode = true;
  
  // 模拟网络延迟（毫秒）
  static const int mockNetworkDelayMs = 800;
}
```

### 禁用 Mock 模式

将 `enableMockMode` 设置为 `false` 以使用真实 API：

```dart
static const bool enableMockMode = false;
```

## Mock 数据详情

### 用户数据 (MockUserApiService)

**模拟用户信息：**
- ID: 用户传入的 userId
- 昵称: John Doe
- 电话: 13800138000
- 头像: https://via.placeholder.com/150
- 邮箱: john.doe@example.com
- VIP 状态: true
- 创建时间: 30 天前

**支持的操作：**
- `getUserInfo(userId)` - 获取用户信息
- `updateUserInfo(userId, data)` - 更新用户信息（支持自定义昵称、头像、邮箱）
- `logout()` - 登出

### 消息数据 (MockMessageApiService)

**模拟消息列表：**
- 总共 50 条消息
- 三种类型：system（系统）、notification（通知）、promotion（促销）
- 每条消息包含：
  - ID: msg_0 到 msg_49
  - 标题: 根据类型自动生成
  - 内容: 根据类型自动生成
  - 已读状态: 每 3 条中有 2 条已读
  - 创建时间: 从现在开始往前推

**支持的操作：**
- `getMessageList(page, pageSize)` - 获取消息列表（支持分页）
- `getUnreadCount()` - 获取未读消息数（固定返回 5）
- `markAsRead(messageId)` - 标记消息为已读
- `getMessageDetail(messageId)` - 获取消息详情

## 配置选项

### 全局 Mock 模式

```dart
// 启用所有 Mock 服务
static const bool enableMockMode = true;
```

### 选择性 Mock

可以分别控制用户和消息 API 的 Mock 状态：

```dart
// 仅 Mock 用户 API
static const bool enableUserMock = true;
static const bool enableMessageMock = false;
```

### 网络延迟

调整模拟网络延迟来测试不同的网络条件：

```dart
// 快速网络（200ms）
static const int mockNetworkDelayMs = 200;

// 正常网络（800ms）
static const int mockNetworkDelayMs = 800;

// 慢速网络（2000ms）
static const int mockNetworkDelayMs = 2000;
```

## 工作原理

### 依赖注入

Mock 模式通过依赖注入实现。在 `lib/injection/mock_locator.dart` 中：

```dart
if (MockConfig.enableUserMock) {
  // 注册 Mock 用户 API 服务
  getIt.registerLazySingleton<UserApiService>(
    () => MockUserApiService(delayMs: MockConfig.mockNetworkDelayMs),
  );
} else {
  // 注册真实用户 API 服务
  getIt.registerLazySingleton<UserApiService>(
    () => UserApiService(getIt<ApiClient>().dio),
  );
}
```

### 数据流

```
UI 层
  ↓
UseCase 层
  ↓
Repository 层
  ↓
API 服务层 (Mock 或 Real)
  ↓
本地缓存 (Isar)
```

## 测试场景

### 场景 1: 测试加载状态

1. 启用 Mock 模式
2. 设置 `mockNetworkDelayMs = 2000`（2 秒延迟）
3. 运行应用，观察加载动画

### 场景 2: 测试消息列表分页

1. 启用 Mock 模式
2. 在消息页面滚动
3. Mock 服务会自动生成分页数据

### 场景 3: 测试离线模式

1. 启用 Mock 模式
2. 加载数据后，禁用网络
3. 数据会从本地缓存加载

### 场景 4: 测试错误处理

可以修改 Mock 服务返回错误响应来测试错误处理逻辑。

## 切换到真实 API

当后端接口准备好时：

1. 编辑 `lib/core/configs/mock_config.dart`
2. 设置 `enableMockMode = false`
3. 确保 `lib/core/configs/flavor_config.dart` 中的 API 基础 URL 正确
4. 重新运行应用

## 扩展 Mock 数据

### 添加更多 Mock 消息

编辑 `lib/data/datasources/mock/mock_message_api_service.dart` 中的 `_generateMockMessages` 方法：

```dart
List<MessageResponse> _generateMockMessages(int page, int pageSize) {
  final messages = <MessageResponse>[];
  // 自定义消息生成逻辑
  return messages;
}
```

### 自定义用户数据

编辑 `lib/data/datasources/mock/mock_user_api_service.dart` 中的 `getUserInfo` 方法：

```dart
@override
Future<BaseResponse<UserResponse>> getUserInfo(String userId) async {
  // 自定义用户数据
  return BaseResponse(
    code: 200,
    message: 'Success',
    data: UserResponse(
      // 自定义字段
    ),
  );
}
```

## 常见问题

### Q: 如何在 Mock 和真实 API 之间快速切换？

A: 编辑 `lib/core/configs/mock_config.dart` 中的 `enableMockMode` 常量，然后重新运行应用。

### Q: Mock 数据会被缓存吗？

A: 是的，Mock 数据会被缓存到本地 Isar 数据库，就像真实 API 数据一样。

### Q: 如何测试网络错误？

A: 修改 Mock 服务返回错误响应，或者禁用网络连接来测试离线模式。

### Q: 生产环境会使用 Mock 数据吗？

A: 不会。确保在构建生产版本前将 `enableMockMode` 设置为 `false`。

## 最佳实践

1. **开发阶段**: 启用 Mock 模式加快开发速度
2. **集成测试**: 使用 Mock 数据进行自动化测试
3. **性能测试**: 调整 `mockNetworkDelayMs` 测试不同网络条件
4. **生产环境**: 禁用 Mock 模式，使用真实 API

## 相关文件

- `lib/core/configs/mock_config.dart` - Mock 配置
- `lib/data/datasources/mock/mock_user_api_service.dart` - 用户 Mock 服务
- `lib/data/datasources/mock/mock_message_api_service.dart` - 消息 Mock 服务
- `lib/injection/mock_locator.dart` - 依赖注入配置
- `lib/main.dart` - 应用入口
