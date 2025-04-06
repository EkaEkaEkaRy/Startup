import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:startup/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:startup/models/receipt_provider.dart';
import 'package:startup/pages/payment_papge.dart';

class ReceiptPage extends StatefulWidget {
  final List<Product> products;
  const ReceiptPage({super.key, required this.products});

  @override
  State<ReceiptPage> createState() => RreceiptPageState();
}

class RreceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);
    final products = receiptProvider.products;

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
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                              border: TableBorder.all(
                                  color: Color.fromARGB(255, 217, 217, 217),
                                  width: 1),
                              columns: [
                                DataColumn(
                                    label: Text('Название',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500))),
                                DataColumn(
                                    label: Text('Кол-во',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500))),
                                DataColumn(
                                    label: Text('Цена',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500)))
                              ],
                              rows: widget.products.map((product) {
                                return DataRow(cells: [
                                  DataCell(Text(product.name,
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400))),
                                  DataCell(Text(product.quantity.toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w400))),
                                  DataCell(Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(product.price.toString(),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.black,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400)),
                                      SizedBox(
                                        width: 40.0,
                                      ),
                                      // кнопка удаления продукта из чека
                                      ElevatedButton(
                                        onPressed: () {
                                          receiptProvider
                                              .removeProduct(product);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Color.fromARGB(
                                                      255, 217, 217, 217)),
                                          shape: WidgetStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                          minimumSize: WidgetStateProperty.all(
                                              Size(130, 35)),
                                          maximumSize: WidgetStateProperty.all(
                                              Size(130, 62)),
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 13,
                                                  horizontal: 10)),
                                          elevation: WidgetStateProperty.all(0),
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Убрать',
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.black,
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )
                                            ]),
                                      )
                                    ],
                                  )),
                                ]);
                              }).toList())),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70.0, vertical: 30.0),
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
                                      fontSize: 24.0,
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
                                  onPressed: () {},
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
                                              fontSize: 20.0,
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
                                        WidgetStateProperty.all(Size(259, 62)),
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
