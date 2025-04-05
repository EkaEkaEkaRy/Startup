import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:startup/pages/scan_page.dart';
import 'package:startup/pages/scan_result_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ScanPage(),
        'scan_result': (context) => ScanResultPage(
              image: (ModalRoute.of(context)?.settings.arguments
                  as Map)['image'] as XFile,
            ),
      },
    );
  }
}
