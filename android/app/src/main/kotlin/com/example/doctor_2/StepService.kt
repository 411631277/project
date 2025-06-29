package com.example.doctor_2

import android.app.*
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import io.flutter.plugin.common.MethodChannel

class StepService : Service(), SensorEventListener {

    private var sensorManager: SensorManager? = null
    private var stepSensor: Sensor? = null
    private var stepCount = 0
    private var channel: MethodChannel? = null

    override fun onCreate() {
        super.onCreate()

        val engine = MainActivity.engine
        channel = MethodChannel(engine!!.dartExecutor.binaryMessenger, "com.example.stepcounter/steps")

        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        stepSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        stepSensor?.let {
            sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_UI)
        }

        createNotificationChannel()
        val notification = NotificationCompat.Builder(this, "step_channel")
            .setContentTitle("步數監測中")
            .setContentText("步數統計")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .build()
        startForeground(1, notification)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        stepCount = event?.values?.get(0)?.toInt() ?: 0
        channel?.invokeMethod("updateSteps", stepCount)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                "step_channel",
                "Step Counter Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }
}
