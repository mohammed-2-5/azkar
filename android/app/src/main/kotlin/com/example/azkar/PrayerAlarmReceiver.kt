package com.example.azkar

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

/**
 * BroadcastReceiver that triggers when a prayer alarm fires.
 * This plays the adhan sound and shows a notification.
 */
class PrayerAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val voiceId = intent.getStringExtra("voice_id") ?: "default"
        val prayerName = intent.getStringExtra("prayer_name") ?: "Prayer"

        Log.d("Azkar", "Prayer alarm received: $prayerName with voice: $voiceId")

        // Show simple notification
        showNotification(context, prayerName)

        // Start service to play sound (with stop button)
        if (voiceId != "default") {
            AdhanService.startPlaying(context, prayerName, voiceId)
            Log.d("Azkar", "Started AdhanService for $prayerName")
        }
    }

    private fun showNotification(context: Context, prayerName: String) {
        val channelId = "prayer_alarm_channel"
        val notificationId = System.currentTimeMillis().toInt()

        // Create notification channel for Android 8.0+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Prayer Alarms",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Prayer time notifications with adhan"
                enableVibration(true)
                enableLights(true)
            }
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }

        // Build and show notification
        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("$prayerName Prayer Time")
            .setContentText("Time for $prayerName prayer")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setAutoCancel(true)
            .setVibrate(longArrayOf(0, 500, 200, 500))
            .build()

        try {
            NotificationManagerCompat.from(context).notify(notificationId, notification)
            Log.d("Azkar", "Notification shown for $prayerName")
        } catch (e: Exception) {
            Log.e("Azkar", "Failed to show notification: ${e.message}")
        }
    }
}
