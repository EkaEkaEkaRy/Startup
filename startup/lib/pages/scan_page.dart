import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/api/api.dart';
import 'package:startup/components/draw_output_image.dart';
import 'package:startup/models/product_model.dart';
import 'package:startup/pages/receipt_page.dart';
//import 'package:cross_file/cross_file.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _controller;
  XFile? _lastImage;
  List<Product> products = [
    Product(name: 'className', price: 400.0, quantity: 1),
    Product(name: 'className2', price: 24.0, quantity: 1),
    Product(name: 'className3', price: 19.0, quantity: 1),
  ];

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
      setState(() {});
    } catch (e) {
      Exception('Ошибка инициализации: $e');
      //print('Ошибка инициализации: $e');
    }
  }

  Future<void> _startCamera() async {
    if (_controller != null && _controller!.value.isInitialized) {
      products = [];
      final image = await _controller!.takePicture();
      List json_image = await Apiservice().getItems(image);
      XFile new_image;
      if (json_image.isNotEmpty) {
        new_image = await drawOutputImage(image, json_image);
        products = [];
        try {
          for (var i in json_image) {
            final className = i['name'];
            if (!products.any((el) => el.name == className)) {
              final priceResponse = await Apiservice().getPrice(className);
              int quantity = 0;
              for (var j in json_image) {
                if (className == j['name']) quantity += 1;
              }
              final product = Product(
                  name: className,
                  price: double.parse(priceResponse) * quantity,
                  quantity: quantity);
              products.add(product);
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        new_image = image;
      }

      setState(() => _lastImage = new_image);

      /*
      final image = await _controller!.takePicture();
      setState(() => _lastImage = image);*/
    }
  }

  Future<void> _stopCamera() async {
    await _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _stopCamera();

    super.dispose();
  }

  Future<void> _scanFood() async {
    _startCamera();
  }

  @override
  Widget build(BuildContext context) {
    return _lastImage == null
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(children: [
                Text('Сканирование',
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 44.0,
                        fontWeight: FontWeight.w500)),
                Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.59,
                      //width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(color: Colors.grey),
                      child: Expanded(
                          child: _controller != null &&
                                  _controller!.value.isInitialized
                              ? CameraPreview(_controller!)
                              : Center(child: Text('Камера недоступна'))),
                    )),
                ElevatedButton(
                  onPressed: _scanFood,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Color.fromARGB(255, 0, 106, 244)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all(Size(259, 35)),
                    maximumSize: WidgetStateProperty.all(Size(259, 62)),
                    padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                    elevation: WidgetStateProperty.all(0),
                  ),
                  child: Text(
                    'Сканировать',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ]),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Сканирование',
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 48.0,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.75,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 242, 242, 242),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: EdgeInsets.all(
                                    0), // Удаление внешних отступов
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.65,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              color: Colors
                                                  .black), // Черная граница между шапкой и остальными строками
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                      color: Colors
                                                          .black), // Черная граница между столбцами
                                                ),
                                              ),
                                              child: Text(
                                                'Название',
                                                style: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                'Количество',
                                                style: GoogleFonts.montserrat(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: products.length,
                                        itemBuilder: (context, index) {
                                          // Остальные строки таблицы
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                    color: Colors
                                                        .grey), // Серая граница между строками
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: BorderSide(
                                                            color: Colors
                                                                .black), // Черная граница между столбцами
                                                      ),
                                                    ),
                                                    child: Text(
                                                        products[index].name),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(products[index]
                                                        .quantity
                                                        .toString()),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.grey,
                                    height: 1,
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: _startCamera,
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 137, 137, 137)),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          minimumSize: WidgetStateProperty.all(
                                              Size(259, 35)),
                                          maximumSize: WidgetStateProperty.all(
                                              Size(259, 62)),
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 15,
                                                  horizontal: 10)),
                                          elevation: WidgetStateProperty.all(0),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.cached,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                'Сканировать',
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontSize: 24.0,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ]),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.2,
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Image.file(
                                              File(_lastImage!.path)))),
                                )
                              : Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 242, 242, 242),
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Center(
                                      child: Text('Начало сканирования')),
                                ),
                          SizedBox(
                            height: 30.0,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              for (var i in products) {
                                print(i.name +
                                    ' ' +
                                    i.price.toString() +
                                    ' ' +
                                    i.price.runtimeType.toString());
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ReceiptPage(products: products)),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  Color.fromARGB(255, 0, 106, 244)),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              minimumSize:
                                  WidgetStateProperty.all(Size(259, 35)),
                              maximumSize:
                                  WidgetStateProperty.all(Size(259, 62)),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10)),
                              elevation: WidgetStateProperty.all(0),
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'далее',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  Icon(
                                    Icons.keyboard_arrow_right,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ]),
                          )
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
