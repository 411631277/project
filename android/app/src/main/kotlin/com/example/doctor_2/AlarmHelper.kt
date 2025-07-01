package com.example.doctor_2

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import java.util.*

object AlarmHelper {
    fun scheduleNextReset(context: Context) {
        val alarmMgr = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, StepResetReceiver::class.java)
        val pi = PendingIntent.getBroadcast(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // 計算「明天 00:01」
        val cal = Calendar.getInstance().apply {
            timeInMillis = System.currentTimeMillis()
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 1)
            set(Calendar.SECOND, 0)
            if (before(Calendar.getInstance())) {
                add(Calendar.DAY_OF_MONTH, 1)
            }
        }

        alarmMgr.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            cal.timeInMillis,
            pi
        )
    }
}
