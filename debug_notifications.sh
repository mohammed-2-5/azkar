#!/bin/bash

# Notification Debug Script for Azkar App
# This script helps debug notification issues

echo "================================================"
echo "Azkar Notification Debug Helper"
echo "================================================"
echo ""

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ ADB not found. Please install Android SDK Platform Tools."
    exit 1
fi

# Check if device is connected
if ! adb devices | grep -q "device$"; then
    echo "❌ No Android device connected."
    echo "   Connect a device via USB or start an emulator."
    exit 1
fi

echo "✅ Device connected"
echo ""

# Function to run command and show output
run_check() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📋 $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    eval "$2"
    echo ""
}

# 1. Check if app is installed
run_check "Checking if Azkar is installed" \
    "adb shell pm list packages | grep com.example.azkar || echo '❌ App not installed'"

# 2. Check notification permission
run_check "Checking notification permission" \
    "adb shell dumpsys notification_listener | grep com.example.azkar -A 5 || echo '⚠️  No notification data found'"

# 3. Check exact alarm permission (Android 12+)
run_check "Checking exact alarm permission" \
    "adb shell dumpsys alarm | grep com.example.azkar -A 5 || echo '⚠️  No scheduled alarms found'"

# 4. Grant permissions (if needed)
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Granting permissions (if needed)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

adb shell pm grant com.example.azkar android.permission.POST_NOTIFICATIONS 2>/dev/null && echo "✅ POST_NOTIFICATIONS granted" || echo "⚠️  Could not grant POST_NOTIFICATIONS (may already be granted)"
adb shell pm grant com.example.azkar android.permission.SCHEDULE_EXACT_ALARM 2>/dev/null && echo "✅ SCHEDULE_EXACT_ALARM granted" || echo "⚠️  Could not grant SCHEDULE_EXACT_ALARM (may require user action)"
adb shell pm grant com.example.azkar android.permission.ACCESS_FINE_LOCATION 2>/dev/null && echo "✅ ACCESS_FINE_LOCATION granted" || echo "⚠️  Could not grant ACCESS_FINE_LOCATION (may already be granted)"
echo ""

# 5. Live log watching
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📡 Live Notification Logs"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Watching for notification-related logs..."
echo "Press Ctrl+C to stop"
echo ""

adb logcat -c  # Clear old logs
adb logcat | grep -E "notifications|Azkar|flutter|prayer_times" --color=always
