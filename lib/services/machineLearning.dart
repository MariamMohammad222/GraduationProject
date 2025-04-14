import 'package:tflite_flutter/tflite_flutter.dart';

class PredictionService {
  late Interpreter _heartModelInterpreter; // موديل القلب
  late Interpreter _temperatureModelInterpreter; // موديل الحرارة

  // تحميل موديل القلب
  Future<void> loadHeartModel() async {
    _heartModelInterpreter = await Interpreter.fromAsset('lstm_ecg_model.tflite');
  }

  // تحميل موديل الحرارة
  Future<void> loadTemperatureModel() async {
    _temperatureModelInterpreter = await Interpreter.fromAsset('temperature_model.tflite');
  }

  // التنبؤ باستخدام موديل القلب
  Future<List<dynamic>> predictHeartModel(List<dynamic> inputData) async {
    var output = List.filled(1, 0); // حجم الناتج المتوقع
    _heartModelInterpreter.run(inputData, output);
    return output;
  }

  // التنبؤ باستخدام موديل الحرارة
  Future<List<dynamic>> predictTemperatureModel(List<dynamic> inputData) async {
    var output = List.filled(1, 0); // حجم الناتج المتوقع
    _temperatureModelInterpreter.run(inputData, output);
    return output;
  }
}

void runHeartPrediction() async {
  var inputData = [72]; // ضربات القلب

  // تأكد من تحميل موديل القلب أولًا
  var predictionService = PredictionService();
  await predictionService.loadHeartModel(); // تحميل موديل القلب
  var prediction = await predictionService.predictHeartModel(inputData);

  print('Heart Prediction: $prediction');
}

