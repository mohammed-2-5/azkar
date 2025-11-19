package com.example.azkar

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * BootReceiver handles BOOT_COMPLETED broadcasts to reschedule notifications
 * after device reboot. This ensures prayer notifications persist across reboots.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON") {

            Log.d("Azkar", "Device booted - notifications will be rescheduled when app opens")

            // Note: Flutter notifications are rescheduled when the app next opens
            // We could launch the app here, but it's better UX to wait until user opens it
            // The PrayerTimesCubit.fetchToday() will reschedule everything automatically
        }
    }
}
