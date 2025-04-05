import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
//import 'package:cross_file/cross_file.dart';

class ScanResultPage extends StatefulWidget {
  const ScanResultPage({super.key, required this.image});
  final XFile image;

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  CameraController? _controller;
  Timer? _timer;
  XFile? _lastImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startCamera();
    _lastImage = widget.image;
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
      //print('Ошибка инициализации: $e');
    }
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

  @override
  void dispose() {
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(children: [
          Text('Сканирование'),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 242, 242, 242),
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration: BoxDecoration(color: Colors.grey),
                        child: _controller != null &&
                                _controller!.value.isInitialized
                            ? CameraPreview(_controller!)
                            : Center(child: Text('Камера недоступна'))),
                    SizedBox(
                      height: 20.0,
                    ),
                    _lastImage != null
                        ? Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Expanded(
                                child: Image.file(File(_lastImage!.path))),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 242, 242, 242),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Center(child: Text('Начало сканирования')),
                          ),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
