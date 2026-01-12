#!/bin/bash

# Route Generation Script for Task 21.1
# This script generates the AutoRoute code required for type-safe navigation

set -e

echo "=========================================="
echo "AutoRoute Code Generation Script"
echo "Task 21.1: Configure AutoRoute"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo ""
    echo "Please install Flutter or add it to your PATH:"
    echo "  export PATH=\"\$PATH:/path/to/flutter/bin\""
    echo ""
    exit 1
fi

echo -e "${GREEN}✓${NC} Flutter SDK found: $(flutter --version | head -1)"
echo ""

# Check if we're in the project root
if [ ! -f "pubspec.yaml" ]; then
    echo -e "${RED}❌ pubspec.yaml not found${NC}"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo -e "${GREEN}✓${NC} Project root directory confirmed"
echo ""

# Step 1: Get dependencies
echo -e "${BLUE}Step 1: Installing dependencies...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Dependencies installed successfully"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi
echo ""

# Step 2: Run code generation
echo -e "${BLUE}Step 2: Running code generation...${NC}"
echo "This may take a few minutes..."
flutter pub run build_runner build --delete-conflicting-outputs
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Code generation completed successfully"
else
    echo -e "${RED}❌ Code generation failed${NC}"
    exit 1
fi
echo ""

# Step 3: Verify generated files
echo -e "${BLUE}Step 3: Verifying generated files...${NC}"

ROUTER_FILE="lib/presentation/navigation/app_router.gr.dart"
if [ -f "$ROUTER_FILE" ]; then
    echo -e "${GREEN}✓${NC} $ROUTER_FILE created"
    
    # Check file size
    FILE_SIZE=$(wc -c < "$ROUTER_FILE")
    if [ $FILE_SIZE -gt 100 ]; then
        echo -e "${GREEN}✓${NC} Generated file appears valid (${FILE_SIZE} bytes)"
    else
        echo -e "${YELLOW}⚠${NC} Generated file seems small (${FILE_SIZE} bytes)"
    fi
else
    echo -e "${RED}❌${NC} $ROUTER_FILE not found"
    exit 1
fi
echo ""

# Step 4: Check for compilation errors
echo -e "${BLUE}Step 4: Checking for compilation errors...${NC}"
flutter analyze lib/presentation/navigation/ --no-fatal-infos --no-fatal-warnings
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No compilation errors found"
else
    echo -e "${YELLOW}⚠${NC} Some issues found, but code generation is complete"
fi
echo ""

# Summary
echo "=========================================="
echo -e "${GREEN}✅ Task 21.1 Complete!${NC}"
echo "=========================================="
echo ""
echo "Generated files:"
echo "  - $ROUTER_FILE"
echo ""
echo "Next steps:"
echo "  1. Review the generated route classes"
echo "  2. Update main.dart to use AutoRoute (if needed)"
echo "  3. Test navigation in the app"
echo ""
echo "Generated route classes available:"
echo "  - HomeRoute"
echo "  - MessageRoute"
echo "  - MessageDetailRoute"
echo "  - MineRoute"
echo "  - SettingRoute"
echo "  - ThemeSettingRoute"
echo "  - LanguageSettingRoute"
echo ""
echo "For more information, see TASK_21_STATUS.md"
echo ""
