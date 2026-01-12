#!/bin/bash

# Deep Link Testing Script for Enterprise Flutter Framework
# This script helps test deep links on Android and iOS

echo "================================"
echo "Deep Link Testing Script"
echo "================================"
echo ""

# Function to test Android deep links
test_android() {
    echo "Testing Android Deep Links..."
    echo ""
    
    # Check if device is connected
    if ! adb devices | grep -q "device$"; then
        echo "❌ No Android device/emulator connected"
        return 1
    fi
    
    echo "Select flavor to test:"
    echo "1) Dev (com.enterprise.flutter.dev)"
    echo "2) Test (com.enterprise.flutter.test)"
    echo "3) Prod (com.enterprise.flutter)"
    read -p "Enter choice (1-3): " flavor_choice
    
    case $flavor_choice in
        1) PACKAGE="com.enterprise.flutter.dev" ;;
        2) PACKAGE="com.enterprise.flutter.test" ;;
        3) PACKAGE="com.enterprise.flutter" ;;
        *) echo "Invalid choice"; return 1 ;;
    esac
    
    echo ""
    echo "Select deep link to test:"
    echo "1) Custom URL: enterpriseflutter://app/home"
    echo "2) Custom URL: enterpriseflutter://app/message"
    echo "3) Custom URL: enterpriseflutter://app/message?id=123"
    echo "4) App Link: https://enterprise.flutter.com/home"
    echo "5) App Link: https://enterprise.flutter.com/message"
    echo "6) App Link: https://enterprise.flutter.com/message?id=123"
    read -p "Enter choice (1-6): " link_choice
    
    case $link_choice in
        1) URL="enterpriseflutter://app/home" ;;
        2) URL="enterpriseflutter://app/message" ;;
        3) URL="enterpriseflutter://app/message?id=123" ;;
        4) URL="https://enterprise.flutter.com/home" ;;
        5) URL="https://enterprise.flutter.com/message" ;;
        6) URL="https://enterprise.flutter.com/message?id=123" ;;
        *) echo "Invalid choice"; return 1 ;;
    esac
    
    echo ""
    echo "Testing: $URL"
    echo "Package: $PACKAGE"
    echo ""
    
    adb shell am start -W -a android.intent.action.VIEW -d "$URL" "$PACKAGE"
    
    if [ $? -eq 0 ]; then
        echo "✅ Deep link test completed"
    else
        echo "❌ Deep link test failed"
    fi
}

# Function to test iOS deep links
test_ios() {
    echo "Testing iOS Deep Links..."
    echo ""
    
    # Check if simulator is running
    if ! xcrun simctl list devices | grep -q "Booted"; then
        echo "❌ No iOS simulator is running"
        echo "Please start an iOS simulator first"
        return 1
    fi
    
    echo "Select deep link to test:"
    echo "1) Custom URL: enterpriseflutter://app/home"
    echo "2) Custom URL: enterpriseflutter://app/message"
    echo "3) Custom URL: enterpriseflutter://app/message?id=123"
    echo "4) Universal Link: https://enterprise.flutter.com/home"
    echo "5) Universal Link: https://enterprise.flutter.com/message"
    echo "6) Universal Link: https://enterprise.flutter.com/message?id=123"
    read -p "Enter choice (1-6): " link_choice
    
    case $link_choice in
        1) URL="enterpriseflutter://app/home" ;;
        2) URL="enterpriseflutter://app/message" ;;
        3) URL="enterpriseflutter://app/message?id=123" ;;
        4) URL="https://enterprise.flutter.com/home" ;;
        5) URL="https://enterprise.flutter.com/message" ;;
        6) URL="https://enterprise.flutter.com/message?id=123" ;;
        *) echo "Invalid choice"; return 1 ;;
    esac
    
    echo ""
    echo "Testing: $URL"
    echo ""
    
    xcrun simctl openurl booted "$URL"
    
    if [ $? -eq 0 ]; then
        echo "✅ Deep link test completed"
    else
        echo "❌ Deep link test failed"
    fi
}

# Function to verify Android App Links
verify_android_app_links() {
    echo "Verifying Android App Links..."
    echo ""
    
    read -p "Enter package name (e.g., com.enterprise.flutter.dev): " package
    
    echo ""
    echo "App Links verification status:"
    adb shell pm get-app-links "$package"
    
    echo ""
    echo "To enable App Links verification:"
    echo "adb shell pm set-app-links --package $package 0 enterprise.flutter.com"
}

# Main menu
echo "Select platform to test:"
echo "1) Android"
echo "2) iOS"
echo "3) Verify Android App Links"
echo "4) Exit"
read -p "Enter choice (1-4): " platform_choice

case $platform_choice in
    1) test_android ;;
    2) test_ios ;;
    3) verify_android_app_links ;;
    4) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

echo ""
echo "================================"
echo "Test completed"
echo "================================"
