package com.example.doctor_2  // <- 換成你的 package

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.HandlerThread
import androidx.work.Worker
import androidx.work.WorkerParameters
import androidx.work.ListenableWorker.Result
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

class StepWorker(
    appContext: Context,
    workerParams: WorkerParameters
) : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        // 1. 取得 SensorManager 與 STEP_COUNTER
        val sensorManager = applicationContext
            .getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
            ?: return Result.failure()

        // 2. 用 HandlerThread 建立有 Looper 的執行緒
        val thread = HandlerThread("StepWorkerThread").apply { start() }
        val handler = Handler(thread.looper)

        // 3. CountDownLatch 等一次回調
        val latch = CountDownLatch(1)
        var steps = 0

        val listener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent) {
                steps = event.values[0].toInt()
                latch.countDown()
            }
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }

        // 4. 註冊 Listener（注意這裡是 4 個參數，最後一個是 android.os.Handler）
        sensorManager.registerListener(
            listener,
            sensor,
            SensorManager.SENSOR_DELAY_NORMAL,
            handler
        )

        // 5. 最多等 3 秒
        latch.await(3, TimeUnit.SECONDS)

        // 6. 清除 Listener & 結束執行緒
        sensorManager.unregisterListener(listener)
        thread.quitSafely()

        // 7. 存步數到 SharedPreferences
        applicationContext
            .getSharedPreferences("step_prefs", Context.MODE_PRIVATE)
            .edit()
            .putInt("last_steps", steps)
            .apply()

        return Result.success()
    }
}
