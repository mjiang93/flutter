#!/bin/bash

# Data Layer Verification Script
# Task 16: Checkpoint - Data layer complete

set -e

echo "=========================================="
echo "Data Layer Verification Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed or not in PATH${NC}"
    echo "Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo -e "${GREEN}✅ Flutter is installed${NC}"
flutter --version
echo ""

# Step 1: Get dependencies
echo "=========================================="
echo "Step 1: Getting dependencies..."
echo "=========================================="
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dependencies installed successfully${NC}"
else
    echo -e "${RED}❌ Failed to install dependencies${NC}"
    exit 1
fi
echo ""

# Step 2: Run code generation
echo "=========================================="
echo "Step 2: Running code generation..."
echo "=========================================="
echo "This may take a few minutes..."
flutter pub run build_runner build --delete-conflicting-outputs
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Code generation completed successfully${NC}"
else
    echo -e "${RED}❌ Code generation failed${NC}"
    exit 1
fi
echo ""

# Step 3: Check generated files
echo "=========================================="
echo "Step 3: Verifying generated files..."
echo "=========================================="

GENERATED_FILES=(
    "lib/data/models/base_response.freezed.dart"
    "lib/data/models/base_response.g.dart"
    "lib/data/models/user_response.freezed.dart"
    "lib/data/models/user_response.g.dart"
    "lib/data/models/message_response.freezed.dart"
    "lib/data/models/message_response.g.dart"
    "lib/data/datasources/remote/api/user_api_service.g.dart"
    "lib/data/datasources/remote/api/message_api_service.g.dart"
    "lib/data/datasources/local/models/user_isar_model.g.dart"
    "lib/data/datasources/local/models/message_isar_model.g.dart"
)

MISSING_FILES=0
for file in "${GENERATED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ Missing: $file${NC}"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -eq 0 ]; then
    echo -e "${GREEN}✅ All generated files present${NC}"
else
    echo -e "${RED}❌ $MISSING_FILES generated files are missing${NC}"
    exit 1
fi
echo ""

# Step 4: Run analyzer on data layer
echo "=========================================="
echo "Step 4: Running Flutter analyzer on data layer..."
echo "=========================================="
flutter analyze lib/data
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ No analysis issues found in data layer${NC}"
else
    echo -e "${YELLOW}⚠️  Analysis issues found - please review${NC}"
fi
echo ""

# Step 5: Check for compilation errors
echo "=========================================="
echo "Step 5: Checking for compilation errors..."
echo "=========================================="
flutter analyze --no-pub
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ No compilation errors${NC}"
else
    echo -e "${RED}❌ Compilation errors found${NC}"
    exit 1
fi
echo ""

# Step 6: Run data layer tests (if they exist)
echo "=========================================="
echo "Step 6: Running data layer tests..."
echo "=========================================="
if [ -d "test/data" ]; then
    flutter test test/data
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ All data layer tests passed${NC}"
    else
        echo -e "${RED}❌ Some data layer tests failed${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  No data layer tests found${NC}"
fi
echo ""

# Step 7: Summary
echo "=========================================="
echo "Verification Summary"
echo "=========================================="
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo -e "${GREEN}✅ Code generation completed${NC}"
echo -e "${GREEN}✅ All generated files present${NC}"
echo -e "${GREEN}✅ No compilation errors${NC}"
echo ""
echo "=========================================="
echo -e "${GREEN}Data layer verification PASSED!${NC}"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Review the DATA_LAYER_VERIFICATION.md file for detailed analysis"
echo "2. Implement missing features (retry logic, request caching)"
echo "3. Write comprehensive tests for repositories and interceptors"
echo "4. Test network interceptors with real API calls"
echo ""
