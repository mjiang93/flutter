#!/bin/bash

# 切换到真实接口模式
# Usage: ./scripts/switch_to_real_api.sh

echo "🔄 切换到真实接口模式..."

# 修改 MockConfig
sed -i '' 's/static const bool enableMockMode = true;/static const bool enableMockMode = false;/g' lib/core/configs/mock_config.dart

echo "✅ 已切换到真实接口模式"
echo "📝 请热重启应用（按 R 键）以使更改生效"
echo ""
echo "⚠️  注意事项："
echo "  - 确保后端 API 地址正确配置"
echo "  - 当前 Dev 环境 API: https://dev-api.example.com"
echo "  - 如需修改，请编辑 lib/main_dev.dart"
echo ""
echo "验证方法："
echo "  - 查看日志中是否有 [Dio] Request 字样"
echo "  - 响应时间取决于实际网络状况"
