package com.example.doctor_2

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import android.content.Intent
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.concurrent.TimeUnit
import androidx.work.ExistingPeriodicWorkPolicy


class MainActivity : FlutterActivity() {
    companion object {
        var engine: FlutterEngine? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val workRequest = PeriodicWorkRequestBuilder<StepWorker>(30, TimeUnit.MINUTES).build()
    WorkManager.getInstance(this).enqueueUniquePeriodicWork(
        "pedometerTask",
        androidx.work.ExistingPeriodicWorkPolicy.REPLACE,
        workRequest
    )

       MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.stepcounter/steps").setMethodCallHandler { call, result ->
    if (call.method == "startStepService") {
        val intent = Intent(this, StepService::class.java)
        startForegroundService(intent)
        result.success(true)
    }
}
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (engine == null) {
            engine = FlutterEngine(this)
            engine!!.dartExecutor.executeDartEntrypoint(
                io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache
                .getInstance()
                .put("my_engine_id", engine)
        }
    }
}
