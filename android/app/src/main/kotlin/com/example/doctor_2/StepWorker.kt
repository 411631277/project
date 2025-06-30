package com.example.doctor_2

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.Looper
import androidx.work.Worker
import androidx.work.WorkerParameters
import android.util.Log
import androidx.work.Result

class StepWorker(appContext: Context, workerParams: WorkerParameters) : Worker(appContext, workerParams), SensorEventListener {

    private var sensorManager: SensorManager? = null
    private var stepSensor: Sensor? = null

    override fun doWork(): Result {
        sensorManager = applicationContext.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        stepSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        stepSensor?.let {
            sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_NORMAL)
        }

        // 使用 Handler 延遲 5 秒後解除註冊，避免阻塞 Worker 執行緒
        Handler(Looper.getMainLooper()).postDelayed({
            sensorManager?.unregisterListener(this)
            Log.d("StepWorker", "停止監聽步數")
        }, 5000)

        return Result.success()
    }

    override fun onSensorChanged(event: android.hardware.SensorEvent?) {
        val stepCount = event?.values?.get(0)?.toInt() ?: 0
        Log.d("StepWorker", "取得步數: $stepCount")
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
