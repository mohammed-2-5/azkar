# Notification Sound Troubleshooting Guide

## Changes Applied

I've made the following improvements to ensure notification sounds play:

### 1. **Increased Importance & Priority**
- Changed from `Importance.high` → `Importance.max`
- Changed from `Priority.high` → `Priority.max`
- This ensures Android gives the notification the highest priority for sound playback

### 2. **Changed Category**
- Changed from `AndroidNotificationCategory.reminder` → `AndroidNotificationCategory.alarm`
- Alarm category bypasses some Do Not Disturb restrictions

### 3. **Added Audio Attributes**
- Added `audioAttributesUsage: AudioAttributesUsage.alarm`
- Explicitly tells Android to use the alarm audio stream (which respects alarm volume)

### 4. **Added Delay After Channel Deletion**
- Added 500ms delay after deleting old channel
- Gives Android time to process the deletion before creating new channel

### 5. **Explicit Audio Settings**
- Added `enableVibration: true`
- Added `enableLights: true`
- Ensures all notification features are enabled

---

## Device Settings to Check

### 1. **Notification Volume**
Make sure your notification/alarm volume is turned up:
- Go to device **Settings** → **Sound**
- Check **Notification volume** slider
- Check **Alarm volume** slider (since we're using alarm category)
- Try setting both to maximum for testing

### 2. **Do Not Disturb Mode**
- Swipe down from top of screen twice (to expand quick settings)
- Check if **Do Not Disturb** is ON (moon icon)
- If ON, either:
  - Turn it OFF for testing
  - Or go to Settings → Sound → Do Not Disturb → Alarms → Enable "Allow alarms"

### 3. **App Notification Settings**
- Settings → Apps → Azkar → Notifications
- Ensure "Allow notifications" is ON
- Tap on the notification category "Prayer Times"
- Ensure:
  - "Sound" is enabled
  - Sound is set to the custom sound (you should see "adhan2" or similar)
  - "Vibration" is enabled

### 4. **Battery Optimization**
Some devices kill background audio for battery saving:
- Settings → Battery → Battery optimization
- Find "Azkar" and set to "Don't optimize"

### 5. **Volume Mixer** (Some Android versions)
- Settings → Sound → Volume
- Ensure all volume sliders are up (especially "Alarm" and "Notification")

---

## Testing Steps

### Test 1: System Sound (Baseline)
1. Hot restart the app: `r` in the terminal running flutter
2. Go to Notifications settings
3. Change "Adhan voice" to **"System Default"**
4. Save
5. Tap "Test adhan notification (15s)"
6. Wait 15 seconds

**Expected**: Notification appears with default system sound

**If this works**: Your device's basic notification sound works. The issue is with custom sounds.

**If this doesn't work**: Check device volume settings above.

---

### Test 2: Custom Sound
1. Change "Adhan voice" to **"Adhan Classic"** or **"Adhan Calm"**
2. Save
3. Tap "Test adhan notification (15s)"
4. Wait 15 seconds

**Expected**: Notification appears with custom adhan sound

**If this works**: ✅ Everything is working!

**If this doesn't work**: Continue to advanced troubleshooting below.

---

## Advanced Troubleshooting

### Check Audio File Format
The MP3 files in `android/app/src/main/res/raw/` are quite large (2.9-3.3MB). Some Android devices have issues with large notification sounds.

**Current files:**
- `adhan1.mp3` - 3.3 MB
- `adhan2.mp3` - 2.9 MB

**Recommendation**: Keep notification sounds under 1 MB

To compress the audio files:
```bash
# Using ffmpeg (if installed)
ffmpeg -i android/app/src/main/res/raw/adhan1.mp3 -ab 128k android/app/src/main/res/raw/adhan1_compressed.mp3
```

Or use an online MP3 compressor.

---

### Check Logs for Errors
When testing, watch the console output for any errors related to sound:
```
grep -i "sound\|audio\|playback"
```

---

### Manual Channel Reset
If sounds are cached, manually clear the app data:
1. Settings → Apps → Azkar
2. Tap "Storage"
3. Tap "Clear Cache"
4. Tap "Clear Data" (⚠️ This will reset all app settings)
5. Reopen the app

---

### Verify Raw Resources
Make sure the audio files are properly included in the build:

```bash
# Check if files are in APK
unzip -l build/app/outputs/flutter-apk/app-debug.apk | grep raw
```

You should see:
```
res/raw/adhan1.mp3
res/raw/adhan2.mp3
```

---

## Alternative: Use URI Instead of Raw Resource

If raw resource sounds continue to not work, you can try using a URI approach. Let me know if you want me to implement this alternative method.

---

## What to Report

If none of the above works, please provide:

1. **Android version**: (e.g., Android 13, 14)
2. **Device model**: (e.g., Pixel 6, Samsung Galaxy S23)
3. **Test results**:
   - Does system default sound work? (Yes/No)
   - Does custom sound work? (Yes/No)
   - Does vibration work? (Yes/No)
4. **Volume settings**:
   - Notification volume: (e.g., 80%)
   - Alarm volume: (e.g., 100%)
5. **Any error messages** from console

This will help me diagnose the specific issue with your device/Android version.
