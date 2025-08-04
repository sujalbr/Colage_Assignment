import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  File? _imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> requestPermissions() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  Future<void> pickImage(ImageSource source) async {
    await requestPermissions();

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task_1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Task_1", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple, // Custom AppBar background color
          actions: [
            Row(
              children: [
                Icon(Icons.light_mode, color: Colors.white),
                Switch(
                  value: isDarkMode,
                  onChanged: (val) {
                    setState(() {
                      isDarkMode = val;
                    });
                  },
                  activeColor: Colors.yellowAccent,
                ),
              ],
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: isDarkMode ? Colors.black : Colors.white,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 20,
                  children: [
                    IconButton(
                      onPressed: () => pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      iconSize: 40,
                      color: Colors.deepPurple, // Icon color
                    ),
                    IconButton(
                      onPressed: () => pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      iconSize: 40,
                      color: Colors.teal, // Icon color
                    ),
                  ],
                ),
                SizedBox(height: 30),
                if (_imageFile != null)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
