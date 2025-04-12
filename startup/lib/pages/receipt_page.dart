import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/api/api.dart';
import 'package:startup/models/product_model.dart';
//import 'package:provider/provider.dart';
import 'package:startup/models/receipt_provider.dart';
import 'package:startup/pages/payment_papge.dart';
import 'package:startup/models/translation.dart';

class ReceiptPage extends StatefulWidget {
  final List<Product> products;
  const ReceiptPage({super.key, required this.products});

  @override
  State<ReceiptPage> createState() => RreceiptPageState();
}

class RreceiptPageState extends State<ReceiptPage> {
  final receiptProvider = ReceiptProvider();
  List<Product> products = [];
  List<Product> menu = [];
  @override
  void initState() {
    receiptProvider.initProduct(widget.products);
    products = receiptProvider.products;
    super.initState();
  }

  // перевод еды с бэка на русский
  String translate(String key) {
    return translations[key] ?? key;
  }

  Future<Product?> showCustomDialog(BuildContext context) async {
    return await showDialog<Product>(
      context: context,
      builder: (BuildContext context) {
        String selectedProduct = '';
        int quantity = 1;

        return StatefulBuilder(
          builder: (context, setState) {
            final items = translations;
            List<DropdownMenuItem<String>> rusItems = items.keys.map((key) {
              return DropdownMenuItem<String>(
                value: key,
                child: Text(items[key]!,
                    style: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.w400)),
              );
            }).toList();

            return Dialog(
              child: Container(
                width: 600,
                height: 400,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Добавить продукт',
                                style: GoogleFonts.montserrat(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: 'Выберите продукт',
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(),
                            ),
                            items: rusItems,
                            onChanged: (value) {
                              setState(() {
                                selectedProduct = value!;
                              });
                            },
                            value: selectedProduct.isEmpty
                                ? null
                                : selectedProduct,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Количество',
                                style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) {
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: 40,
                                    ),
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (quantity <= 10) {
                                        setState(() {
                                          quantity++;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: 40,
                                    ),
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(null); // Возвращаем null
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Color.fromARGB(255, 0, 106, 244),
                            ),
                            child: Text(
                              'Отмена',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16.0,
                                  color:
                                      const Color.fromARGB(255, 118, 118, 118),
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final priceResponse =
                                  await Apiservice().getPrice(selectedProduct);
                              final product = Product(
                                name: translate(selectedProduct),
                                price: double.parse(priceResponse) * quantity,
                                quantity: quantity,
                              );
                              Navigator.of(context)
                                  .pop(product); // Возвращаем продукт
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
                                  WidgetStateProperty.all(Size(259, 50)),
                              maximumSize:
                                  WidgetStateProperty.all(Size(259, 60)),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10)),
                              elevation: WidgetStateProperty.all(0),
                            ),
                            child: Text(
                              'Добавить',
                              style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Чек",
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 44.0,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                color: Color.fromARGB(255, 242, 242, 242),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 36.0, left: 41.0, right: 41.0),
                      child: Container(
                          padding:
                              EdgeInsets.all(0), // Удаление внешних отступов
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.45,
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
                                        child: Text('Название',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                color: Colors
                                                    .black), // Черная граница между столбцами
                                          ),
                                        ),
                                        child: Text('Количество',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text('Цена',
                                            style: GoogleFonts.montserrat(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
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
                                              height: 55.0,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                      color: Colors
                                                          .black), // Черная граница между столбцами
                                                ),
                                              ),
                                              child: Text(products[index].name,
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 55.0,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(
                                                      color: Colors
                                                          .black), // Черная граница между столбцами
                                                ),
                                              ),
                                              child: Text(
                                                  products[index]
                                                      .quantity
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 55.0,
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                  products[index]
                                                      .price
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  receiptProvider.removeProduct(
                                                      products[index]);
                                                  products =
                                                      receiptProvider.products;
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        Color.fromARGB(255, 217,
                                                            217, 217)),
                                                shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                minimumSize:
                                                    WidgetStateProperty.all(
                                                        Size(130, 35)),
                                                maximumSize:
                                                    WidgetStateProperty.all(
                                                        Size(130, 60)),
                                                padding:
                                                    WidgetStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                            vertical: 13,
                                                            horizontal: 10)),
                                                elevation:
                                                    WidgetStateProperty.all(0),
                                              ),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Убрать',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    )
                                                  ]),
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
                    ),
                    Container(
                      color: Colors.grey,
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70.0, vertical: 20.0),
                        child: Column(
                          children: [
                            // вывод итоговой суммы
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Итого: ${receiptProvider.totalSum.toString()}',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // кнопка добавления продукта в чек (пока без функции)
                                ElevatedButton(
                                  onPressed: () async {
                                    final newProduct =
                                        await showCustomDialog(context);
                                    if (newProduct != null) {
                                      setState(() {
                                        receiptProvider.addProduct(newProduct);
                                        products = receiptProvider.products;
                                      });
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                        Color.fromARGB(255, 217, 217, 217)),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    minimumSize:
                                        WidgetStateProperty.all(Size(150, 35)),
                                    maximumSize:
                                        WidgetStateProperty.all(Size(150, 62)),
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 13, horizontal: 10)),
                                    elevation: WidgetStateProperty.all(0),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Добавить',
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ]),
                                ),

                                // кнопка перехода на следующую страницу (оплата)
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentPapge()),
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
                                        WidgetStateProperty.all(Size(259, 60)),
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 10)),
                                    elevation: WidgetStateProperty.all(0),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }
}
