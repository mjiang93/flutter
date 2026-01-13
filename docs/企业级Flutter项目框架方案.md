# 企业级Flutter项目框架方案

本文档为可直接复制使用的企业级Flutter项目框架生成提示词，基于2026年最新Flutter技术栈，融合DDD+Clean Architecture设计思想，覆盖大型商业应用所需的核心能力、工程化规范、业务适配方案，确保生成的框架具备高可扩展性、高健壮性、高性能。

# 一、核心生成要求（总纲）

基于 Flutter 3.24.0（2026最新稳定版）生成一套可支撑千万级用户规模大型商业应用的企业级Flutter基础项目框架，严格遵循「分层解耦、类型安全、工程化落地、高性能优化、全场景适配」核心原则，要求代码可直接运行、注释完整、文档详尽，具备生产级交付标准。

# 二、技术栈选型（2026最优方案，含版本适配与选型依据）

|能力领域|核心技术选型（含版本）|精细化选型理由|实现规范要求|
|---|---|---|---|
|基础框架|Flutter 3.24.0|2026年Q1稳定版，修复Flutter 3.x系列历史内存泄漏问题，提升iOS 17/Android 14兼容性，优化Web/Desktop跨平台性能|必须使用空安全模式，禁止使用过时API（如FlatButton、RaisedButton），统一替换为Material 3组件|
|状态管理|GetX 5.0.0 + Flutter Hooks 0.19.0 + Freezed 2.4.6|GetX5.0优化状态响应性能，支持自动销毁；Flutter Hooks简化轻量组件状态；Freezed实现不可变数据类，避免数据竞态|全局状态使用GetX单例+持久化，页面状态用GetX Controller+AutoDispose，组件状态用Hooks；所有数据模型通过Freezed生成|
|路由管理|GetX Router + AutoRoute 7.3.0（代码生成）|AutoRoute提供100%类型安全路由，避免参数传递错误；支持深度链接、路由拦截、转场动画配置，适配App Links/Universal Links|路由命名规范：模块名_页面名（如home_index、message_detail）；必须生成路由参数实体类，禁止动态拼接参数|
|网络请求|Dio 5.5.0 + Retrofit 4.1.0 + json_serializable 6.8.1|Retrofit通过注解生成API接口，类型安全无冗余代码；Dio5.5.0支持HTTP/2，优化并发请求性能；json_serializable提升序列化效率|所有API接口必须定义在独立接口类中，请求/响应模型单独封装；统一请求超时时间（连接3s、接收10s）|
|本地存储|Isar 3.1.0 + SharedPreferences 2.2.2|Isar替代Hive，支持索引查询、事务、跨平台，性能提升30%+；SharedPreferences适用于轻量配置存储，API简洁|结构化数据（用户信息、列表缓存）用Isar，轻量配置（主题、语言）用SharedPreferences；敏感数据（token）存储需AES加密|
|网络状态监听|connectivity_plus 5.0.2 + network_info_plus 4.0.1|支持WiFi 6/5G网络类型识别，精准监听网络切换状态；适配多平台（iOS/Android/Web/Windows/macOS）|网络状态变化需发送全局事件，页面可按需监听；断网时自动缓存未发送的埋点数据|
|主题/换肤|flutter_theme_mode_manager 2.0.1 + Provider 6.1.1|支持亮色/暗色/跟随系统/自定义主题四模式；Provider实现主题依赖注入，低侵入式更新UI，性能优于InheritedWidget|主题色定义需区分品牌色、功能色、中性色；字体大小、圆角、间距统一封装为主题常量，支持动态调整|
|列表优化|flutter_list_view 2.0.3 + infinite_scroll_pagination 4.0.0|flutter_list_view支持item回收复用、预加载，避免OOM；infinite_scroll_pagination标准化上拉加载/下拉刷新逻辑|列表项必须使用const构造函数（静态内容）；预加载触发阈值设为屏幕高度的1.5倍；滑动时暂停图片加载|
|工程化工具|Melos 4.1.0 + Flutter Flavor 2.1.0 + flutter_lints 3.0.1|Melos支持多包管理，实现业务模块拆分；Flavor实现多环境隔离，无需修改代码切换配置；flutter_lints强制代码规范|至少配置dev（开发）、test（测试）、prod（生产）三个环境；每个业务模块独立为Melos子包，依赖通过pubspec.yaml声明|
|日志/崩溃上报|logger 2.0.2 + firebase_crashlytics 3.4.3 + flutter_logger 1.0.1|logger支持分级日志（debug/info/warn/error），格式化输出；Firebase Crashlytics自动捕获崩溃并上报，支持自定义事件|开发环境输出详细日志（含请求参数），生产环境仅输出error级日志并脱敏；崩溃上报需携带设备信息、用户ID、版本号|
|权限管理|permission_handler 11.1.0 + permission_handler_android 12.0.1|适配Android 14权限分组机制，支持iOS 17新权限（如照片精选访问）；统一权限申请流程，减少冗余代码|权限申请前必须弹出自定义说明弹窗（告知用户权限用途）；拒绝权限后引导用户到系统设置页，提供跳转按钮|
|国际化|easy_localization 3.0.7 + flutter_localizations|支持多语言切换、Plural复数、Gender性别适配、资产文件（JSON/YAML）加载；无需重启应用即可生效|所有文案必须使用国际化key，禁止硬编码；默认支持中/英双语，预留多语言扩展接口；文案按模块拆分存储（如home_i18n.json）|
|埋点统计|firebase_analytics 10.4.5 + umeng_analytics 6.1.0（国内备选）|支持页面埋点（自动统计停留时长）、点击埋点、自定义事件；离线缓存埋点数据，网络恢复后自动上报|埋点事件名规范：模块名_事件类型（如home_refresh、message_click）；事件参数必须包含timestamp（时间戳）、device_id（设备ID）|
|原生交互|Pigeon 1.1.0|Google官方推荐，替代MethodChannel，支持类型安全的Flutter-原生交互；自动生成两端代码，避免序列化错误|定义统一的交互协议（.dart文件），生成Android（Kotlin）/iOS（Swift）代码；原生方法必须包含异常捕获，返回统一错误格式|
# 三、项目架构设计（DDD+Clean Architecture 融合，精细化目录结构）

## 3.1 架构分层原则

严格遵循「依赖倒置原则」，上层依赖下层接口，不依赖具体实现；分层从内到外依次为：核心层 → 领域层 → 数据层 → 表现层，禁止反向依赖。

## 3.2 精细化目录结构（含文件说明）

```plaintext

/lib
  /core                  // 核心层：框架级能力，不依赖任何业务模块
    /configs             // 全局配置
      app_config.dart    // 应用基础配置（版本号、包名、API基础地址）
      flavor_config.dart // 多环境配置（dev/test/prod的差异化参数）
      route_config.dart  // 路由基础配置（默认转场动画、拦截器）
    /constants           // 常量定义
      app_constants.dart // 应用常量（如页面数量限制、缓存时长）
      error_code.dart    // 错误码常量（系统错误/业务错误）
      route_names.dart   // 路由名常量（统一管理，避免硬编码）
      cache_keys.dart    // 缓存key常量（Isar/SP的key定义）
    /errors              // 统一异常体系
      base_exception.dart // 基础异常类
      network_exception.dart // 网络异常（断网/超时/404等）
      business_exception.dart // 业务异常（错误码非200）
      system_exception.dart // 系统异常（序列化失败/空指针等）
    /extensions          // 扩展方法
      dart_extensions.dart // Dart基础类扩展（String/int/bool）
      flutter_extensions.dart // Flutter组件扩展（BuildContext/Widget）
    /utils               // 工具类（纯功能，无状态）
      encryption_util.dart // 加密工具（AES/RSA）
      format_util.dart   // 格式化工具（日期/金额/手机号）
      validation_util.dart // 校验工具（手机号/邮箱/身份证）
      log_util.dart      // 日志工具（封装logger）
  /domain                // 领域层：核心业务，纯Dart，无外部依赖
    /entities            // 业务实体（核心数据模型，与UI解耦）
      user_entity.dart   // 用户实体
      message_entity.dart // 消息实体
    /repositories        // 仓储接口（定义数据操作规范，不关心实现）
      user_repository.dart // 用户相关数据操作接口
      message_repository.dart // 消息相关数据操作接口
    /usecases            // 业务用例（封装单一业务逻辑）
      home
        get_home_data_usecase.dart // 获取首页数据用例
      message
        get_unread_message_usecase.dart // 获取未读消息用例
        mark_message_read_usecase.dart // 标记消息已读用例
      mine
        get_user_info_usecase.dart // 获取用户信息用例
        logout_usecase.dart // 退出登录用例
    /value_objects       // 值对象（带校验规则的基础数据）
      user_id.dart       // 用户ID（校验非空/格式）
      phone_number.dart  // 手机号（校验格式）
      email.dart         // 邮箱（校验格式）
  /data                  // 数据层：实现仓储接口，处理数据来源
    /datasources         // 数据源（远程/本地）
      /remote            // 远程数据源
        api_client.dart  // Retrofit生成的API客户端
        /services        // 远程服务接口
          home_api_service.dart // 首页API接口
          message_api_service.dart // 消息API接口
          user_api_service.dart // 用户API接口
      /local             // 本地数据源
        /isar            // Isar相关
          isar_manager.dart // Isar实例管理
          user_isar_dao.dart // 用户数据DAO
          message_isar_dao.dart // 消息数据DAO
        /sp              // SharedPreferences相关
          sp_manager.dart // SP实例管理
    /models              // 数据模型（请求/响应模型，适配网络/本地存储）
      /request
        home_request.dart // 首页相关请求模型
        message_request.dart // 消息相关请求模型
      /response
        base_response.dart // 基础响应模型（code/message/data）
        home_response.dart // 首页相关响应模型
        message_response.dart // 消息相关响应模型
    /repositories        // 仓储实现（连接远程/本地数据源）
      user_repository_impl.dart // 用户仓储接口实现
      message_repository_impl.dart // 消息仓储接口实现
  /presentation          // 表现层：UI相关，依赖领域层
    /blocs/controllers   // 状态控制器（连接UI与领域层）
      home_controller.dart // 首页控制器
      message_controller.dart // 消息控制器
      mine_controller.dart // 我的控制器
      theme_controller.dart // 主题控制器
      network_controller.dart // 网络状态控制器
    /pages               // 页面（按模块拆分）
      /home
        home_page.dart   // 首页
        /widgets         // 首页私有组件
          home_banner_widget.dart // 首页轮播组件
          home_list_item_widget.dart // 首页列表项组件
      /message
        message_page.dart // 消息页
        message_detail_page.dart // 消息详情页
        /widgets
          message_item_widget.dart // 消息项组件
          unread_badge_widget.dart // 未读角标组件
      /mine
        mine_page.dart   // 我的页
        setting_page.dart // 设置页
        theme_setting_page.dart // 主题设置页
        /widgets
          user_info_widget.dart // 用户信息组件
    /widgets             // 通用组件（全局复用）
      /base
        base_page.dart   // 基础页面（统一AppBar/生命周期/异常处理）
        base_state.dart  // 基础状态（统一UI状态格式）
      /refresh
        refresh_load_more_list.dart // 下拉刷新+上拉加载列表组件
      /empty
        empty_widget.dart // 空页面组件（无数据/无网络/错误/权限不足）
      /loading
        loading_widget.dart // 加载组件（全局加载/局部加载）
        skeleton_widget.dart // 骨架屏组件
      /theme
        theme_switcher_widget.dart // 主题切换组件
    /navigation          // 路由配置
      app_router.dart    // AutoRoute生成的路由配置
      router_interceptor.dart // 路由拦截器（未登录拦截/权限拦截）
    /theme               // 主题配置
      app_theme.dart     // 主题定义（颜色/字体/样式）
      theme_extensions.dart // 主题扩展（自定义主题属性）
  /injection             // 依赖注入（管理实例，解耦）
    locator.dart         // GetIt配置，注册所有需要注入的实例
  /app                   // 应用入口封装
    app.dart             // 应用根组件
  main.dart              // 入口文件（初始化依赖、启动应用）

// 工程化相关文件（根目录）
/pubspec.yaml           // 依赖配置
/melos.yaml             // Melos多包配置
/flutter_flavor_config  // Flavor环境配置
  dev.dart
  test.dart
  prod.dart
/build.gradle           // Android构建配置
/Info.plist             // iOS配置
/README.md              // 项目说明文档

```

# 四、核心能力实现规范（精细化技术细节）

## 4.1 基础UI与导航规范

1. 底部Tab实现
        

    - 基于`BottomNavigationBar`封装`AppBottomTabBar`组件，支持3个Tab（首页/消息/我的）

    - Tab状态绑定GetX控制器，未读消息角标数据从`MessageController`获取，自动更新

    - 支持双击Tab回到顶部功能（首页列表/消息列表），通过`ScrollController`实现

    - Tab切换动画使用淡入淡出（`FadeTransition`），时长300ms，避免生硬跳转

2. 页面规范
        

    - 所有页面必须继承`BasePage`，统一页面骨架（AppBar+Body+Loading+Error状态）

    - AppBar统一封装，支持左侧返回按钮、右侧操作按钮、标题样式自定义

    - 页面生命周期统一管理，通过`BasePage`封装`onCreate/onResume/onPause/onDestroy`

## 4.2 状态管理规范

1. 状态分层管控
        

    - 全局状态（用户信息、主题、网络状态）：使用`GetX`单例（`Get.put(..., permanent: true)`）+ Isar持久化，支持跨页面共享

    - 页面状态：使用`GetX Controller` + `AutoDispose`，页面销毁时自动释放资源，避免内存泄漏

    - 组件状态：轻量状态（如按钮选中、输入框内容）使用`Flutter Hooks`（`useState/useEffect/useMemoized`），替代`StatefulWidget`减少冗余代码

2. 状态格式规范
        

    - 所有控制器必须继承`BaseController`，统一UI状态枚举：`idle（初始）、loading（加载中）、success（成功）、error（错误）、empty（空数据）`

    - 状态更新必须通过`update()`（GetX）或`setState()`（Hooks），禁止直接修改状态变量后不通知UI

    - 业务状态与UI状态分离，业务状态（如用户登录状态）单独定义，UI状态仅用于控制页面展示

## 4.3 网络层实现规范

1. 多环境配置
        

    - 通过`Flutter Flavor`配置3个环境：dev（开发，API地址：https://dev-api.xxx.com）、test（测试，https://test-api.xxx.com）、prod（生产，https://api.xxx.com）

    - 环境切换通过打包命令实现：`flutter run --flavor dev`、`flutter build apk --flavor prod`

    - 每个环境的差异化配置（如超时时间、日志级别）统一放在`flavor_config.dart`中

2. 拦截器体系（精细化实现）
        

    - 请求拦截器（RequestInterceptor）
                

        - 自动添加请求头：token（从Isar获取）、device-id（设备唯一标识）、app-version（应用版本）、os-type（系统类型，iOS/Android）、lang（当前语言）

        - 请求参数加密：非GET请求的参数需进行AES加密（密钥从环境配置获取），GET参数不加密但需URL编码

        - 重复请求防抖：同一接口（相同URL+参数）在未响应前，禁止重复发起，通过`CancelToken`实现

    - 响应拦截器（ResponseInterceptor）
               

        - 统一解析响应格式：`{code: int, message: String, data: dynamic}`，封装为`BaseResponse<T>`泛型类

        - 错误码映射处理：
                        

            - code=200：正常返回数据，解析`data`字段为对应模型

            - code=401：未登录/Token过期，自动清除本地用户信息，跳转登录页（通过路由拦截器）

            - code=403：权限不足，弹出提示弹窗，返回上一页

            - code=404：接口不存在，记录错误日志，展示通用错误页面

            - code=500/502/503/504：服务器错误，展示重试按钮，支持用户手动重试

            - 其他业务错误（如code=1001：参数错误）：展示`message`字段内容

        - 响应数据解密：如果响应数据是加密的，自动进行AES解密后再解析

    - 异常拦截器（DioErrorInterceptor）
    

        - 网络异常：断网（NoInternetConnectionException）、连接超时（ConnectionTimeoutException）、接收超时（ReceiveTimeoutException）

        - 系统异常：序列化失败（JsonSerializableException）、空指针（NullPointerException）

        - 统一异常转换：将DioError转换为自定义的`NetworkException`或`SystemException`，上层仅处理自定义异常

3. 请求能力强化
        

    - 泛型请求方法：封装`get<T>()`、`post<T>()`、`put<T>()`、`delete<T>()`、`patch<T>()`方法，支持指定响应模型类型，自动解析

    - 请求取消：每个页面控制器持有一个`CancelToken`，页面销毁时调用`cancel()`，取消所有未完成的请求

    - 请求重试：网络异常时自动重试，最多3次，采用指数退避策略（第1次间隔1s，第2次2s，第3次4s）

    - 请求缓存：支持按接口配置缓存策略，如首页数据缓存5分钟，用户信息缓存30分钟；缓存key为URL+参数的MD5值

4. 空数据处理
        

    - 当响应`code=200`但`data`为空（或空列表）时，自动触发空页面展示

    - 空页面支持自定义文案和图片，如无数据时显示“暂无数据”，无网络时显示“网络连接失败，请检查网络”

## 4.4 通用UI组件实现规范

1. 列表组件（`RefreshLoadMoreList`）
       

    - 下拉刷新：基于`RefreshIndicator`，支持自定义刷新头部（显示刷新状态/时间）

    - 上拉加载更多：滑动到底部自动触发，显示加载中动画；无更多数据时显示“没有更多数据了”

    - 状态展示：
                

        - 加载中：显示骨架屏（替代传统加载动画，提升用户体验）

        - 空数据：显示`EmptyWidget`，提示“暂无数据”

        - 加载失败：显示错误提示文字+重试按钮，点击重试重新请求数据

    - 性能优化：
                

        - 使用`flutter_list_view`实现item回收复用，避免一次性渲染所有item

        - 预加载：当滑动到当前列表最后一个item的1.5倍屏幕高度时，提前加载下一页数据

        - 滑动优化：滑动时暂停图片加载，停止滑动后恢复加载（通过`ScrollController`监听）

2. 空页面组件（`EmptyWidget`）
        

    - 支持4种场景：无数据（default）、无网络（network）、请求失败（error）、权限不足（permission）

    - 每种场景对应不同的图标和文案，可通过参数自定义（如`EmptyWidget(type: EmptyType.network, customText: '网络连接失败')`）

    - 支持自定义操作按钮，如无网络时显示“重新连接”按钮，点击触发网络重连

3. 主题切换组件（`ThemeSwitcherWidget`）
        

    - 支持4种主题模式切换：亮色、暗色、跟随系统、自定义（用户选择自定义颜色）

    - 切换后自动更新全局UI，主题配置持久化到SharedPreferences，下次启动恢复上次设置

    - 提供主题预览功能，切换前可预览效果

## 4.5 全局能力监听规范

1. 网络状态监听
        

    - 封装`NetworkManager`单例，通过`connectivity_plus`监听网络状态变化

    - 网络状态变化时发送全局事件（通过`GetX`的`EventBus`），页面可通过`ever()`监听事件

    - 断网时弹出全局Toast提示“网络连接已断开”，网络恢复时提示“网络已恢复”

    - 断网期间未发送成功的网络请求（如埋点、数据提交）自动缓存到Isar，网络恢复后按顺序重试

2. 全局异常处理
        

    - 捕获Flutter框架异常：通过`FlutterError.onError`捕获，记录日志并上报Crashlytics

    - 捕获Dart异步异常：通过`runZonedGuarded`捕获，避免未捕获异常导致APP崩溃

    - 统一错误提示：所有未处理的异常最终展示为通用错误页面，提供“返回首页”和“重试”按钮

# 五、工程化与可维护性规范

## 5.1 代码规范

1. 强制规范
        

    - 遵循Dart官方规范（Effective Dart），集成`flutter_lints 3.0.1`，启用所有严格检查规则

    - 禁止使用`print()`，统一使用`LogUtil`工具类打印日志

    - 严格遵守空安全规则，禁止使用`!`强制非空，禁止使用`dynamic`（除非必要）

2. 命名规范
        

    - 类名：大驼峰（PascalCase），如`HomePage`、`UserRepository`

    - 方法名/变量名：小驼峰（camelCase），如`getUserInfo`、`isLogin`

    - 常量名：全大写+下划线（UPPER_SNAKE_CASE），如`API_BASE_URL`、`ERROR_CODE_UNLOGIN`

    - 文件名：小写下划线（snake_case），与类名对应，如`home_page.dart`、`user_repository.dart`

    - 路由名：小写下划线（snake_case），格式为“模块名_页面名”，如`home_index`、`message_detail`

3. 注释规范
       

    - 类注释：每个类必须添加文档注释（///），说明类的作用、核心功能、使用场景

    - 方法注释：每个公共方法必须添加文档注释，说明方法作用、参数含义、返回值、异常情况

    - 行内注释：核心逻辑、复杂判断、临时解决方案必须添加行内注释，说明原因

    - 生成API文档：使用`dartdoc`工具生成API文档，包含所有公共类和方法

## 5.2 性能优化规范

1. 内存优化
        

    - 避免全局持有`BuildContext`，如需使用上下文，通过`Get.context`获取

    - 及时释放资源：页面销毁时取消未完成的网络请求、停止动画、释放`ScrollController`等

    - 列表优化：使用`ListView.builder`（原生）或`flutter_list_view`，避免使用`ListView(children: [...])`一次性渲染所有item

    - 图片优化：使用`cached_network_image`缓存网络图片，设置合适的图片尺寸，避免大图缩放

2. 渲染优化
       

    - 静态组件使用`const`构造函数，避免不必要的重建

    - 使用`RepaintBoundary`隔离重绘区域，避免局部组件变化导致全局重绘

    - 避免在`build()`方法中创建对象（如`List<Widget>`、控制器），应缓存到变量中

    - 减少Widget嵌套层级，嵌套不超过5层；复杂UI拆分为多个小组件

3. 启动优化
        

    - 延迟初始化非核心组件：如主题设置、国际化等非首屏必需的组件，通过`Future.delayed`延迟初始化

    - 预加载首页数据：在应用启动时提前请求首页数据，减少首屏加载时间

    - 优化首屏渲染：首屏组件尽量简洁，避免复杂计算和大量图片加载

## 5.3 多包管理（Melos）规范

1. 模块拆分：按功能拆分为多个Melos子包
        

    - core：核心能力包（工具类、常量、异常等）

    - domain：领域层包（业务实体、用例等）

    - data：数据层包（网络、本地存储等）

    - presentation_home：首页表现层包

    - presentation_message：消息表现层包

    - presentation_mine：我的表现层包

2. 依赖管理：
        

    - 子包之间的依赖通过`melos.yaml`声明，如`presentation_home`依赖`core`、`domain`、`data`

    - 公共依赖（如GetX、Dio）统一在根目录`pubspec.yaml`中声明版本，子包继承版本，避免版本冲突

3. 命令规范：
        

    - 安装所有依赖：`melos bootstrap`

    - 运行指定子包：`melos run start:home`

    - 运行所有子包的测试：`melos run test`

# 六、业务基础功能实现要求

## 6.1 首页模块

1. 核心功能：
        

    - 展示首页轮播图（Banner），通过GET请求获取Banner数据

    - 展示首页列表数据（如新闻、商品），支持下拉刷新更新数据、上拉加载更多

    - 列表项点击跳转详情页（通过AutoRoute路由）

2. 状态处理：


    - 首次进入加载中：显示骨架屏

    - 加载成功：显示轮播图+列表

    - 加载失败：显示错误空页面，支持重试

    - 无数据：显示无数据空页面

## 6.2 消息模块

1. 核心功能：


    - 展示未读消息列表，未读消息右上角显示红色角标（数字）

    - 点击消息标记为已读（调用PUT请求）

    - 点击消息进入详情页，展示消息完整内容

    - 支持下拉刷新更新消息列表

2. 数据缓存：
        

    - 消息列表数据缓存到Isar，断网时展示缓存数据

    - 未读消息数量缓存到全局状态，支持跨页面访问（如底部Tab角标）

## 6.3 我的模块

1. 核心功能：
        

    - 展示用户信息（头像、昵称、手机号），通过GET请求获取

    - 支持退出登录（调用DELETE请求清除登录状态），退出后跳转登录页（路由拦截）

    - 提供主题设置入口，跳转主题设置页

    - 提供语言设置入口，支持中/英双语切换

2. 状态持久化：
        

    - 用户信息缓存到Isar，登录状态缓存到SharedPreferences

    - 退出登录时清除所有本地缓存的用户相关数据（用户信息、token等）

# 七、输出要求（精细化交付标准）

1. 完整项目代码：
        

    - 包含上述所有目录和文件，代码无语法错误、无警告，可直接运行（支持iOS/Android模拟器/真机）

    - pubspec.yaml配置完整，所有依赖版本正确，无冲突；包含代码生成相关依赖（build_runner、retrofit_generator等）

    - 提供代码生成脚本（在pubspec.yaml中配置）：`flutter pub run build_runner build --delete-conflicting-outputs`

    - 包含原生配置文件：Android（build.gradle、AndroidManifest.xml）、iOS（Podfile、Info.plist），适配最新系统版本

2. 注释要求：
        

    - 所有公共类、公共方法必须添加详细文档注释（///），说明作用、参数、返回值、异常

    - 核心逻辑（如网络拦截器、状态管理、业务用例）添加行内注释，说明设计思路和关键步骤

    - 代码生成相关的注解（如@RestApi、@JsonSerializable）添加注释，说明用途

3. 文档要求：
        

    - 提供完整的README.md，包含：
                

        - 项目介绍：架构设计、核心技术栈、模块划分

        - 环境配置：开发环境搭建、Flavor多环境配置、依赖安装

        - 启动步骤：本地运行命令、打包命令

        - 核心能力使用示例：网络请求、状态管理、路由跳转、主题切换等

        - 代码规范：命名规范、注释规范、提交规范

        - 常见问题：依赖冲突、编译错误、运行异常的解决方案

    - 提供项目架构图（Mermaid语法），放在README.md中，直观展示分层结构和模块依赖

    - 提供API文档（通过dartdoc生成），包含所有公共类和方法的说明

4. 测试要求：
        

    - 包含单元测试：覆盖核心工具类（加密、格式化、校验）、网络层（拦截器、请求方法）、业务用例

    - 单元测试覆盖率≥80%，提供测试报告（通过`flutter test --coverage`生成）

    - 包含Widget测试：覆盖核心UI组件（列表、空页面、主题切换组件）

5. 功能验证：
        

    - 确保所有核心功能正常工作：Tab切换、网络请求（GET/POST/PUT/DELETE）、列表上拉加载/下拉刷新、空页面展示、网络状态监听、主题切换、权限申请、国际化切换、埋点上报、原生交互

    - 提供功能验证清单，列出所有需要验证的功能点和验证方法

# 八、扩展能力预留（支撑未来业务扩展）

1. 插件化能力：预留插件化架构接口，支持动态加载插件模块（如通过`flutter_plugin_loader`）

2. 推送能力：预留推送服务接口（支持Firebase Push/极光推送/个推），统一推送消息处理逻辑

3. 支付能力：预留支付接口（支持微信支付/支付宝支付/Apple Pay），封装统一支付流程

4. IM能力：预留IM接口（支持融云/环信/Tencent IM），封装消息发送/接收/状态同步逻辑

5. 统计分析：预留用户行为分析接口，支持扩展更多维度的埋点事件
> （注：文档部分内容可能由 AI 生成）