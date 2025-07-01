package com.example.doctor_2

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager

class StepResetReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        // 每次觸發後，先排程下一次的鬧鐘
        AlarmHelper.scheduleNextReset(ctx)

        // 透過 WorkManager 執行一次步數讀取/重置
        val work = OneTimeWorkRequestBuilder<StepWorker>().build()
        WorkManager.getInstance(ctx).enqueue(work)
    }
}