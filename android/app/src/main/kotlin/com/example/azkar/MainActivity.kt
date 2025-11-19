package com.example.azkar

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val DIAGNOSTICS_CHANNEL = "azkar/diagnostics"
    private val ALARM_CHANNEL = "azkar/alarm"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Diagnostics channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DIAGNOSTICS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getNotificationVolume" -> {
                    val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    val volume = audioManager.getStreamVolume(AudioManager.STREAM_NOTIFICATION)
                    val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_NOTIFICATION)
                    val percentage = if (maxVolume > 0) (volume * 100) / maxVolume else 0
                    result.success(percentage)
                }
                "getAlarmVolume" -> {
                    val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    val volume = audioManager.getStreamVolume(AudioManager.STREAM_ALARM)
                    val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_ALARM)
                    val percentage = if (maxVolume > 0) (volume * 100) / maxVolume else 0
                    result.success(percentage)
                }
                "getRingerMode" -> {
                    val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    val mode = when (audioManager.ringerMode) {
                        AudioManager.RINGER_MODE_SILENT -> "SILENT"
                        AudioManager.RINGER_MODE_VIBRATE -> "VIBRATE"
                        AudioManager.RINGER_MODE_NORMAL -> "NORMAL"
                        else -> "UNKNOWN"
                    }
                    result.success(mode)
                }
                "areNotificationsEnabled" -> {
                    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    val enabled = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                        notificationManager.areNotificationsEnabled()
                    } else {
                        true // Assume enabled on older versions
                    }
                    result.success(enabled)
                }
                "getZenMode" -> {
                    val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                    val zenMode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        notificationManager.currentInterruptionFilter
                    } else {
                        0 // DND not available on older versions
                    }
                    result.success(zenMode)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // Alarm channel for scheduling sounds
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ALARM_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleAlarmSound" -> {
                    val time = call.argument<Long>("time") ?: 0L
                    val prayerName = call.argument<String>("prayer_name") ?: ""
                    val voiceId = call.argument<String>("voice_id") ?: "default"
                    val notificationId = call.argument<Int>("notification_id") ?: 0

                    try {
                        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        val intent = Intent(this, PrayerAlarmReceiver::class.java).apply {
                            putExtra("prayer_name", prayerName)
                            putExtra("voice_id", voiceId)
                        }

                        val pendingIntent = PendingIntent.getBroadcast(
                            this,
                            notificationId + 10000, // Offset to avoid collision with notification IDs
                            intent,
                            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                        )

                        // Use exact alarm for precise timing
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            alarmManager.setExactAndAllowWhileIdle(
                                AlarmManager.RTC_WAKEUP,
                                time,
                                pendingIntent
                            )
                        } else {
                            alarmManager.setExact(
                                AlarmManager.RTC_WAKEUP,
                                time,
                                pendingIntent
                            )
                        }

                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ALARM_ERROR", "Failed to schedule alarm: ${e.message}", null)
                    }
                }
                "cancelAllAlarms" -> {
                    try {
                        // Cancel pending alarms (would need to track IDs in production)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("CANCEL_ERROR", "Failed to cancel alarms: ${e.message}", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
