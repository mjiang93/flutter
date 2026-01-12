#!/bin/bash

# 切换到 Mock 数据模式
# Usage: ./scripts/switch_to_mock.sh

echo "🔄 切换到 Mock 数据模式..."

# 修改 MockConfig
sed -i '' 's/static const bool enableMockMode = false;/static const bool enableMockMode = true;/g' lib/core/configs/mock_config.dart

echo "✅ 已切换到 Mock 数据模式"
echo "📝 请热重启应用（按 R 键）以使更改生效"
echo ""
echo "验证方法："
echo "  - 查看日志中是否有 [MockUserApiService] 或 [MockMessageApiService]"
echo "  - Mock 数据响应时间固定为 800ms"
