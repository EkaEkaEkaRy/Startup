import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPapge extends StatefulWidget {
  const PaymentPapge({super.key});

  @override
  State<PaymentPapge> createState() => _PaymentPapgeState();
}

class _PaymentPapgeState extends State<PaymentPapge> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Оплата",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 44.0,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(
            height: 125.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.network('src'),
                  SizedBox(
                    height: 27.0,
                  ),
                  Text('СБП / SberPay',
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w400))
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}
