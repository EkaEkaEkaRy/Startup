import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    void forgetPassword() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0), // Скоругление
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4525,
              child: Center(
                child: Column(
                  children: [
                    Text('Позвоните по номеру'),
                    Text('+7(888)888-88-88'),
                    Text('или напишите на нашу почту'),
                    Text('mail@mail.ru')
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Хорошо"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 242, 242, 242)),
              height: MediaQuery.of(context).size.height * 0.625,
              width: MediaQuery.of(context).size.width * 0.5775,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Вход'),
                  TextField(),
                  TextField(),
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) => {}),
                      Text('Запомнить меня')
                    ],
                  ),
                  ElevatedButton(onPressed: () {}, child: Text('Вход'))
                ],
              ),
            ),
            TextButton(onPressed: forgetPassword, child: Text('Забыли пароль?'))
          ],
        ),
      ),
    );
  }
}
