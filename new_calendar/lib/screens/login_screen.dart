import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController senhaController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //lembrar de conferir se email e senha correspondem
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text("Entrar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gender-register');
              },
              child: Text("Não tem uma conta? Cadastre-se"),
            ),
          ],
        ),
      ),
    );
  }
}
