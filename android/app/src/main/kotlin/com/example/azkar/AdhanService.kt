package com.example.azkar

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat

/**
 * Foreground service that plays adhan sounds.
 * This allows the sound to play reliably and provides controls to stop it.
 */
class AdhanService : Service() {
    private var mediaPlayer: MediaPlayer? = null
    private val CHANNEL_ID = "adhan_playback_channel"
    private val NOTIFICATION_ID = 1001

    companion object {
        const val ACTION_PLAY = "com.example.azkar.ACTION_PLAY_ADHAN"
        const val ACTION_STOP = "com.example.azkar.ACTION_STOP_ADHAN"
        const val EXTRA_VOICE_ID = "voice_id"
        const val EXTRA_PRAYER_NAME = "prayer_name"

        fun startPlaying(context: Context, prayerName: String, voiceId: String) {
            val intent = Intent(context, AdhanService::class.java).apply {
                action = ACTION_PLAY
                putExtra(EXTRA_PRAYER_NAME, prayerName)
                putExtra(EXTRA_VOICE_ID, voiceId)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            val intent = Intent(context, AdhanService::class.java).apply {
                action = ACTION_STOP
            }
            context.startService(intent)
        }
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_PLAY -> {
                val prayerName = intent.getStringExtra(EXTRA_PRAYER_NAME) ?: "Prayer"
                val voiceId = intent.getStringExtra(EXTRA_VOICE_ID) ?: "default"
                playAdhan(prayerName, voiceId)
            }
            ACTION_STOP -> {
                stopAdhan()
            }
        }
        return START_NOT_STICKY
    }

    private fun playAdhan(prayerName: String, voiceId: String) {
        val soundResId = when (voiceId) {
            "adhan1" -> R.raw.adhan1
            "adhan2" -> R.raw.adhan2
            else -> null
        }

        if (soundResId == null) {
            Log.w("AdhanService", "No sound resource for voice: $voiceId")
            stopSelf()
            return
        }

        try {
            // Stop any existing playback
            mediaPlayer?.release()

            // Create and start new MediaPlayer
            mediaPlayer = MediaPlayer.create(this, soundResId)?.apply {
                setOnCompletionListener {
                    Log.d("AdhanService", "Adhan playback completed")
                    stopSelf()
                }
                setOnErrorListener { _, what, extra ->
                    Log.e("AdhanService", "MediaPlayer error: what=$what, extra=$extra")
                    stopSelf()
                    true
                }
            }

            // Start foreground with notification
            val notification = createPlaybackNotification(prayerName)
            startForeground(NOTIFICATION_ID, notification)

            // Start playback
            mediaPlayer?.start()
            Log.d("AdhanService", "Playing adhan for $prayerName with voice $voiceId")

        } catch (e: Exception) {
            Log.e("AdhanService", "Failed to play adhan: ${e.message}", e)
            stopSelf()
        }
    }

    private fun stopAdhan() {
        Log.d("AdhanService", "Stopping adhan playback")
        mediaPlayer?.apply {
            if (isPlaying) {
                stop()
            }
            release()
        }
        mediaPlayer = null
        stopForeground(true)
        stopSelf()
    }

    private fun createPlaybackNotification(prayerName: String): Notification {
        // Create stop intent
        val stopIntent = Intent(this, AdhanService::class.java).apply {
            action = ACTION_STOP
        }
        val stopPendingIntent = PendingIntent.getService(
            this,
            0,
            stopIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("$prayerName Prayer Time")
            .setContentText("Playing adhan...")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setOngoing(true)
            .addAction(
                android.R.drawable.ic_media_pause,
                "Stop",
                stopPendingIntent
            )
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Adhan Playback",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Shows when adhan is playing"
                setSound(null, null) // No sound for this channel
            }
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        mediaPlayer?.release()
        mediaPlayer = null
        Log.d("AdhanService", "Service destroyed")
    }
}
