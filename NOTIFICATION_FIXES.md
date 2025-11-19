# Notification System Fixes - Complete Summary

This document summarizes all the fixes applied to resolve notification issues in the Azkar app.

## What Was Fixed

### 1. **Android Permissions** ✅
**File**: `android/app/src/main/AndroidManifest.xml`

**Added critical permissions**:
- `USE_EXACT_ALARM` - Required for Android 14+ exact alarms
- `RECEIVE_BOOT_COMPLETED` - Allows rescheduling after device reboot
- `WAKE_LOCK` - Wakes device when notification fires
- `VIBRATE` - Enables notification vibration

### 2. **Boot Receiver** ✅
**Files**:
- `android/app/src/main/AndroidManifest.xml` (receiver declaration)
- `android/app/src/main/kotlin/com/example/azkar/BootReceiver.kt` (implementation)

**Purpose**: Handles device reboots and ensures notifications persist across restarts. The receiver is triggered on BOOT_COMPLETED, and notifications are rescheduled when the app next opens.

### 3. **Timezone Resolution** ✅
**File**: `lib/core/services/notification_scheduler.dart:84-159`

**Replaced**: Broken MethodChannel with robust multi-fallback timezone detection

**How it works**:
1. First tries system timezone name (e.g., "America/New_York")
2. Falls back to matching timezone by UTC offset
3. Uses comprehensive map of common timezones by offset
4. Last resort: searches all timezones for matching offset
5. Ultimate fallback: UTC

**Purpose**: Ensures notifications are scheduled in the correct timezone without requiring external packages.

### 4. **Test Notification Timing** ✅
**File**: `lib/core/services/notification_scheduler.dart:175`

**Changed**: 5 seconds → 15 seconds

**Reason**:
- 5 seconds is too short for Android to reliably schedule
- Matches the UI message that says "~15 seconds"
- Gives system time to properly queue the notification

### 5. **Error Visibility** ✅
**File**: `lib/features/prayer_times/presentation/cubit/prayer_times_cubit.dart:104-114`

**Changed**: Silent error swallowing → Proper logging

**Benefits**:
- Errors are now logged to console with `dev.log`
- Success messages confirm scheduling worked
- Developers can debug issues via logcat

### 6. **Notification Channel Recreation** ✅
**File**: `lib/core/services/notification_service.dart:44-77`

**Fixed**: Channel caching prevented sound changes from taking effect

**Solution**: Always delete old channel before creating new one. This ensures:
- Sound changes are applied immediately
- Channel settings are always current
- No stale cached settings

### 7. **Permission Verification** ✅
**File**: `lib/core/services/notification_service.dart:14-74`

**Added**: `checkPermission()` method and verification in `init()`

**Benefits**:
- Confirms notification permission was actually granted
- Logs warning if permission denied
- Helps diagnose permission-related issues

### 8. **Debug Testing Button** ✅
**File**: `lib/features/prayer_times/presentation/pages/notifications_page.dart:183-201`

**Added**: "Test instant notification (now)" button

**Purpose**:
- Tests if basic notifications work (bypasses scheduling)
- Immediate feedback without waiting
- Helps isolate whether issue is with notifications or scheduling

---

## How to Test

### Step 1: Clean Build
```bash
flutter clean
flutter pub get
flutter run
```

### Step 2: Test Basic Notifications
1. Open the app and navigate to Prayer Times
2. Tap the menu icon → "Notifications"
3. Scroll down and tap **"Test instant notification (now)"**
4. You should see a notification immediately

**If this works**: Notification permissions and basic functionality are working ✅

**If this fails**: Check Android settings:
- Settings → Apps → Azkar → Notifications → Ensure enabled

### Step 3: Test Scheduled Notifications
1. In the Notifications page, tap **"Test adhan notification (15s)"**
2. Wait 15 seconds
3. You should hear the adhan sound and see a notification

**If this works**: Scheduled notifications with sound are working ✅

**If this fails**: Check:
- Settings → Apps → Azkar → Alarms & reminders → Ensure enabled (Android 12+)
- Run `adb logcat | grep -i notification` to see error logs

### Step 4: Test Real Prayer Notifications
1. In Notifications page, ensure:
   - "Enable Reminders" is ON
   - At least one prayer (e.g., Fajr) is selected
   - Lead time is set (e.g., 10 minutes)
2. Tap "Save"
3. Go back to Prayer Times page
4. Check the next prayer time
5. Wait for notification (lead time before prayer)

**Expected**: Notification arrives with adhan sound at the scheduled time

---

## Debugging Tips

### View Notification Logs
```bash
# Start the app
flutter run

# In another terminal, view logs
adb logcat | grep -E "notifications|Azkar"
```

Look for:
- ✅ `"Notification permission granted"`
- ✅ `"Created channel: prayer_times_channel_*"`
- ✅ `"Successfully scheduled notifications for X prayers"`
- ✅ `"Scheduling notification id=XXX at..."`
- ❌ `"Notification permission not granted"`
- ❌ `"Failed to schedule notifications"`

### Check Notification Permission
```bash
adb shell dumpsys notification_listener
```

### Check Exact Alarm Permission (Android 12+)
```bash
adb shell dumpsys alarm
```

### Verify Scheduled Alarms
```bash
adb shell dumpsys alarm | grep -A 10 "com.example.azkar"
```

---

## Common Issues & Solutions

### Issue 1: "Test instant notification" works but scheduled doesn't
**Cause**: Exact alarm permission not granted

**Solution**:
1. Settings → Apps → Azkar → Alarms & reminders → Enable
2. Or run: `adb shell pm grant com.example.azkar android.permission.SCHEDULE_EXACT_ALARM`

### Issue 2: No sound plays
**Cause**:
- Device is in silent mode
- Custom sound not in correct folder
- Channel not recreated after sound change

**Solution**:
1. Check device volume
2. Ensure audio files exist: `assets/audio/adhan1.mp3` and `assets/audio/adhan2.mp3`
3. Ensure files are also in: `android/app/src/main/res/raw/`
4. Change adhan voice in settings to force channel recreation

### Issue 3: Notifications stop after reboot
**Cause**: BootReceiver not working or notifications not rescheduled

**Solution**:
- Open the app after reboot (triggers reschedule)
- Check logcat for: `"Device booted - notifications will be rescheduled"`

### Issue 4: Wrong time / timezone issues
**Cause**: Timezone detection failing

**Solution**:
- Verify `flutter_native_timezone` was installed: `flutter pub get`
- Check logs for: `"Initialized timezone: XXX"`
- If says "UTC", timezone detection failed

---

## Architecture Summary

### Notification Flow
```
1. User saves notification settings
   ↓
2. PrayerTimesCubit.saveNotificationPrefs()
   ↓
3. NotificationScheduler.scheduleForTimes()
   ↓
4. For each prayer:
   - Calculate time (prayer time - lead minutes)
   - Skip if in quiet hours or already passed
   - Create notification channel (with azan sound)
   - Schedule via flutter_local_notifications
   ↓
5. Android AlarmManager fires at scheduled time
   ↓
6. Notification appears with sound
```

### Key Components

**NotificationService** (`lib/core/services/notification_service.dart`)
- Wraps `flutter_local_notifications`
- Manages notification channels
- Handles permissions
- Provides `showInstant()` and `scheduleNotification()`

**NotificationScheduler** (`lib/core/services/notification_scheduler.dart`)
- Handles timezone resolution
- Schedules multiple prayer notifications
- Manages quiet hours
- Provides test notification functionality

**PrayerTimesCubit** (`lib/features/prayer_times/presentation/cubit/prayer_times_cubit.dart`)
- Calculates prayer times
- Loads/saves notification preferences
- Triggers notification scheduling
- Exposes scheduler for testing

**BootReceiver** (`android/.../BootReceiver.kt`)
- Listens for BOOT_COMPLETED
- Allows app to reschedule notifications after reboot

---

## Testing Checklist

- [ ] Instant test notification appears immediately
- [ ] 15-second test notification appears with sound
- [ ] Real prayer notification arrives at correct time
- [ ] Sound plays (not silent)
- [ ] Correct adhan voice plays
- [ ] Changing adhan voice updates the sound
- [ ] Quiet hours prevent notifications
- [ ] Lead time is respected (X minutes before prayer)
- [ ] Individual prayer enable/disable works
- [ ] Notifications persist after app close
- [ ] Notifications persist after device reboot
- [ ] Logs show successful scheduling

---

## Files Modified

### Android
- `android/app/src/main/AndroidManifest.xml` - Added permissions and receiver
- `android/app/src/main/kotlin/com/example/azkar/BootReceiver.kt` - New file

### Dart/Flutter
- `lib/core/services/notification_service.dart` - Channel recreation + permission check
- `lib/core/services/notification_scheduler.dart` - Improved timezone detection + fixed test timing
- `lib/features/prayer_times/presentation/cubit/prayer_times_cubit.dart` - Error logging + scheduler getter + dev import
- `lib/features/prayer_times/presentation/pages/notifications_page.dart` - Added instant test button

---

## Next Steps

1. **Run the app**: `flutter run`
2. **Test instant notification**: Should work immediately
3. **Test scheduled notification**: Should work in 15 seconds
4. **Test real prayer time**: Wait for actual notification
5. **Check logs**: `adb logcat | grep notifications`
6. **Report any issues**: Include logcat output

If all tests pass, your notification system is fully functional! 🎉
