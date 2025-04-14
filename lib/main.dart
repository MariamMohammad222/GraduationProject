import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

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
  TextEditingController _tempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _predictionService = PredictionService();
    _loadModels();
  }

  Future<void> _loadModels() async {
    try {
      await _predictionService.loadTemperatureModel();
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

  void _runTemperaturePrediction() async {
    if (!_isModelLoaded) {
      print("Model not loaded!");
      return;
    }

    double? inputTemp = double.tryParse(_tempController.text.trim());

    if (inputTemp == null) {
      setState(() {
        _temperaturePrediction = '❗ أدخل درجة حرارة صحيحة!';
      });
      return;
    }

    try {
      var prediction = await _predictionService.predictTemperatureModel([inputTemp]);

      int predictedIndex = prediction.indexOf(prediction.reduce((a, b) => a > b ? a : b));
      String label = "";

      switch (predictedIndex) {
        case 0:
          label = "Above Normal (Fever)";
          break;
        case 1:
          label = "Below Normal (Hypothermia)";
          break;
        case 2:
          label = "Normal";
          break;
        default:
          label = "Unknown";
      }

      setState(() {
        _temperaturePrediction = '📊 Prediction: $label\n\n'
            'Probabilities:\n'
            '🔥 Above Normal: ${prediction[0].toStringAsFixed(2)}\n'
            '❄️ Below Normal: ${prediction[1].toStringAsFixed(2)}\n'
            '✅ Normal: ${prediction[2].toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() {
        _temperaturePrediction = '❌ Error predicting: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temperature Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter temperature (°C)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _runTemperaturePrediction,
                child: Text('Run Temperature Prediction'),
              ),
              SizedBox(height: 20),
              if (!_isModelLoaded)
                CircularProgressIndicator(),
              if (_temperaturePrediction.isNotEmpty)
                Text(
                  _temperaturePrediction,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PredictionService {
  late Interpreter _temperatureModelInterpreter;

  Future<void> loadTemperatureModel() async {
    try {
      _temperatureModelInterpreter =
          await Interpreter.fromAsset('models/temperature_model (1).tflite');
      print('Model loaded');
    } catch (e) {
      print('Error loading temperature model: $e');
      throw Exception('Failed to load model');
    }
  }

  Future<List<double>> predictTemperatureModel(List<double> inputData) async {
    double mean = 36.8;
    double std = 0.8;
    var scaledInput = [(inputData[0] - mean) / std];
    var input = [scaledInput]; // 2D list: [[value]]
    var output = List.generate(1, (_) => List.filled(3, 0.0)); // 1x3 output

    _temperatureModelInterpreter.run(input, output);
    return output[0];
  }
}
