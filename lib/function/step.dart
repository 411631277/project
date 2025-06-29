import 'package:flutter/services.dart';

class StepCounterService {
  static const platform = MethodChannel('com.example.stepcounter/steps');

  static Future<void> startStepService() async {
    await platform.invokeMethod('startStepService');
  }
}
