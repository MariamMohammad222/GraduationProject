import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projectgraduation/constants/colorview.dart';

class CameraWidget extends StatefulWidget {
  final String userId;
  const CameraWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserImage();
  }

  /// تحميل الصورة المخزنة محليًا
  Future<void> _loadUserImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_${widget.userId}.jpg';
    final imageFile = File(imagePath);

    if (await imageFile.exists()) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  /// التقاط صورة وحفظها محليًا
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/profile_${widget.userId}.jpg';
      final imageFile = await File(pickedFile.path).copy(imagePath);

      setState(() {
        _imageFile = imageFile;
      });

      print("تم حفظ الصورة محليًا في: $imagePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppUI.colorPrimary, width: 2),
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null
                ? Icon(Icons.person, size: 40, color: Colors.grey)
                : null,
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: InkWell(
            onTap: () => _pickImage(ImageSource.gallery),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppUI.colorPrimary, width: 1),
              ),
              child: Icon(Icons.camera, color: AppUI.colorPrimary, size: 16),
            ),
          ),
        ),
      ],
    );
  }
}
