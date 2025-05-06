import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PredictionPage(),
    );
  }
}

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  late PredictionService _predictionService;
  bool _isModelLoaded = false;
  String _temperaturePrediction = '';
  String _heartRatePrediction = '';
  TextEditingController _tempController = TextEditingController();
  TextEditingController _hrController = TextEditingController();
 final TextEditingController _bpmController = TextEditingController();
final TextEditingController _hrvController = TextEditingController();
final TextEditingController _qrsController = TextEditingController();
final TextEditingController _stController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _predictionService = PredictionService();
    _loadModels();
  }

  Future<void> _loadModels() async {
    try {
      // await _predictionService.loadTemperatureModel();
      await _predictionService.loadHeartRateModel();
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      print('Error loading models: $e');
      setState(() {
        _isModelLoaded = false;
      });
    }
  }

  // void _runTemperaturePrediction() async {
  //   double? inputTemp = double.tryParse(_tempController.text.trim());

  //   if (inputTemp == null) {
  //     setState(() {
  //       _temperaturePrediction = '❗ أدخل درجة حرارة صحيحة!';
  //     });
  //     return;
  //   }

  //   try {
  //     var prediction = await _predictionService.predictTemperatureModel([inputTemp]);

  //     int predictedIndex = prediction.indexOf(prediction.reduce((a, b) => a > b ? a : b));
  //     String label = "";

  //     switch (predictedIndex) {
  //       case 0:
  //         label = "Above Normal (Fever)";
  //         break;
  //       case 1:
  //         label = "Below Normal (Hypothermia)";
  //         break;
  //       case 2:
  //         label = "Normal";
  //         break;
  //       default:
  //         label = "Unknown";
  //     }

  //     setState(() {
  //       _temperaturePrediction = '📊 Temperature Prediction: $label\n\n'
  //           '🔥 Above Normal: ${prediction[0].toStringAsFixed(2)}\n'
  //           '❄️ Below Normal: ${prediction[1].toStringAsFixed(2)}\n'
  //           '✅ Normal: ${prediction[2].toStringAsFixed(2)}';
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _temperaturePrediction = '❌ Error predicting temperature: $e';
  //     });
  //   }
  // }

 void _runHeartRatePrediction() async {
  try {
    final bpm = double.parse(_bpmController.text.trim());
    final hrv = double.parse(_hrvController.text.trim());
    final qrs = double.parse(_qrsController.text.trim());
    final st = double.parse(_stController.text.trim());

    final prediction = await _predictionService.predictHeartRateModel(
      bpm: bpm,
      hrv: hrv,
      qrs: qrs,
      st: st,
    );

    final index = prediction.indexOf(prediction.reduce((a, b) => a > b ? a : b));
    final label = switch (index) {
      0 => 'Normal',
      1 => 'Panic Attack',
      2 => 'Epilepsy',
      _ => 'Unknown',
    };

    setState(() {
      _heartRatePrediction = '❤️ Heart Condition: $label\n'
          '🧠 Panic: ${prediction[1].toStringAsFixed(2)}\n'
          '⚡ Epilepsy: ${prediction[2].toStringAsFixed(2)}\n'
          '✅ Normal: ${prediction[0].toStringAsFixed(2)}';
    });
  } catch (e) {
    setState(() {
      _heartRatePrediction = '❗ تأكد من إدخال كل القيم بشكل صحيح';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Health Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isModelLoaded
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    // درجة الحرارة
                    TextField(
                      controller: _tempController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter temperature (°C)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // ElevatedButton(
                    //   onPressed: _runTemperaturePrediction,
                    //   child: Text('Predict Temperature'),
                    // ),
                    SizedBox(height: 10),
                    Text(
                      _temperaturePrediction,
                      textAlign: TextAlign.center,
                    ),
                    Divider(height: 40),

                    // نبض القلب
                    TextField(
                      controller: _hrController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter heart rate (BPM)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _runHeartRatePrediction,
                      child: Text('Predict Heart Rate'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _heartRatePrediction,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class PredictionService {
  late Interpreter _temperatureModelInterpreter;
  late Interpreter _heartRateModelInterpreter;

  // تحميل موديل الحرارة
  // Future<void> loadTemperatureModel() async {
  //   _temperatureModelInterpreter =
  //       await Interpreter.fromAsset('models/temperature_model1.tflite');
  // }

  // تحميل موديل نبض القلب
Future<Interpreter?> loadHeartRateModel() async {
  Interpreter? interpreter;
  GpuDelegateV2? gpuDelegate;

  try {
    // المحاولة باستخدام GPU أولاً
    try {
      gpuDelegate = GpuDelegateV2();
      final options = InterpreterOptions()..addDelegate(gpuDelegate);
      
      interpreter = await Interpreter.fromAsset(
        'heart_rate_model.tflite',
        options: options,
      );
      print("✅ تم تحميل موديل معدل ضربات القلب باستخدام GPU بنجاح");
      return interpreter;
    } catch (gpuError) {
      print("⚠️ لا يوجد دعم لتسريع GPU، يتم الانتقال لاستخدام CPU. الخطأ: $gpuError");
      gpuDelegate = null; // لا حاجة لإغلاقه كما في الإصدارات القديمة
    }

    // الانتقال لاستخدام CPU
    interpreter = await Interpreter.fromAsset('heart_rate_model.tflite');
    print("✅ تم تحميل موديل معدل ضربات القلب باستخدام CPU بنجاح");
    return interpreter;

  } catch (e) {
    print("❌ فشل تحميل الموديل. الخطأ: $e");
    interpreter?.close(); // إغلاق الإنتربرتر فقط إذا كان موجوداً
    return null;
  }
}  // توقع الحرارة
  // Future<List<double>> predictTemperatureModel(List<double> inputData) async {
  //   double mean = 36.8;
  //   double std = 0.8;
  //   var scaledInput = [(inputData[0] - mean) / std];
  //   var input = [scaledInput]; // 2D list: [[value]]
  //   var output = List.generate(1, (_) => List.filled(3, 0.0)); // 1x3 output

  //   _temperatureModelInterpreter.run(input, output);
  //   return output[0];
  // }

  // توقع نبض القلب
Future<List<double>> predictHeartRateModel({
  required double bpm,
  required double hrv,
  required double qrs,
  required double st,
}) async {
  // نفس القيم اللي استخدمتيها في التدريب
  final means = [75.0, 0.7, 0.1, 0.2]; // مثال: حسب البيانات عندك
  final stds = [10.0, 0.2, 0.02, 0.05];

  final inputRaw = [bpm, hrv, qrs, st];

  // نطبق التحجيم: (x - mean) / std
  final scaled = List.generate(
    4,
    (i) => (inputRaw[i] - means[i]) / stds[i],
  );

  final input = [[[scaled[0], scaled[1], scaled[2], scaled[3]]]];

  final output = List.generate(1, (_) => List.filled(3, 0.0)); // 1x3 output

  _heartRateModelInterpreter.run(input, output);
  return output[0];
}

}

