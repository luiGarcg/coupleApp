import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("Homem"),
                Radio(value: 0, groupValue: 1, onChanged: (value) {}),
                Text("Mulher"),
                Radio(value: 1, groupValue: 1, onChanged: (value) {}),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gender-register');
              },
              child: Text("Próximo"),
            ),
          ],
        ),
      ),
    );
  }
}
