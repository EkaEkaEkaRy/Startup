import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:cross_file/cross_file.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Timer? _timer;
  XFile? _lastImage;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _controller!.initialize();
      }
    } catch (e) {
      //print(e);
    }
  }

  Future<void> _toggleCamera() async {
    if (_isActive) {
      await _stopCamera();
    } else {
      await _startCamera();
    }
    setState(() => _isActive = !_isActive);
  }

  Future<void> _startCamera() async {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (_controller != null && _controller!.value.isInitialized) {
        final image = await _controller!.takePicture();
        setState(() => _lastImage = image);
      }
    });
  }

  Future<void> _stopCamera() async {
    _timer?.cancel();
    await _controller?.dispose();
    _controller = null;
  }

  Future<void> _saveImage() async {
    if (_lastImage == null) return;

    final directory = await getDownloadsDirectory();
    final savePath = '${directory!.path}/CameraPhotos';
    await Directory(savePath).create(recursive: true);

    final file = File('$savePath/${_lastImage!.name}');
    await file.writeAsBytes(await _lastImage!.readAsBytes());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved to: ${file.path}')),
    );
  }

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desktop Camera')),
      body: Column(
        children: [
          Expanded(
              child: _controller != null && _controller!.value.isInitialized
                  ? CameraPreview(_controller!)
                  : Center(child: Text('Camera not available'))),
          if (_lastImage != null)
            Expanded(child: Image.file(File(_lastImage!.path))),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _toggleCamera,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isActive ? Colors.red : Colors.green,
                  ),
                  child: Text(_isActive ? 'Stop' : 'Start'),
                ),
                ElevatedButton(
                  onPressed: _saveImage,
                  child: Text('Save Image'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
