import 'package:flutter/material.dart';

class GenderRegisterScreen extends StatefulWidget {
  @override
  _GenderRegisterScreenState createState() => _GenderRegisterScreenState();
}

class _GenderRegisterScreenState extends State<GenderRegisterScreen> {
  String selectedGender = 'Homem';
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();
  TextEditingController codigoController = TextEditingController();
  TextEditingController duracaoMenstruacaoController = TextEditingController();
  TextEditingController tempoPausaAnticoncepcionalController =
      TextEditingController();
  String generatedCode = '';
  int menstruacaoDays = 0;
  int anticoncepcionalBreak = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Homem"),
                    value: 'Homem',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text("Mulher"),
                    value: 'Mulher',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            TextField(
              controller: confirmarSenhaController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirmar Senha'),
            ),
            if (selectedGender == 'Mulher') ...[
              DropdownButtonFormField<int>(
                value: menstruacaoDays,
                decoration: InputDecoration(
                    labelText: 'Quantos dias dura sua menstruação?'),
                onChanged: (value) {
                  setState(() {
                    menstruacaoDays = value!;
                  });
                },
                items: List.generate(11, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text('$index'),
                  );
                }),
              ),
              DropdownButtonFormField<int>(
                value: anticoncepcionalBreak,
                decoration: InputDecoration(
                    labelText:
                        'Qual o tempo de pausa do seu anticoncepcional?'),
                onChanged: (value) {
                  setState(() {
                    anticoncepcionalBreak = value!;
                  });
                },
                items: List.generate(11, (index) {
                  return DropdownMenuItem(
                    value: index,
                    child: Text('$index'),
                  );
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    generatedCode = generateRandomCode();
                  });
                },
                child: Text("Gerar Código"),
              ),
              if (generatedCode.isNotEmpty)
                Text("Código gerado: $generatedCode"),
            ],
            if (selectedGender == 'Homem') ...[
              TextField(
                controller: codigoController,
                decoration: InputDecoration(labelText: 'Código da parceira'),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                // Colocar banco de dados para salvar
              },
              child: Text("Salvar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text("Já possui uma conta? Login"),
            ),
          ],
        ),
      ),
    );
  }

  String generateRandomCode() {
    final random = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final codeLength = 6;
    String code = '';
    for (int i = 0; i < codeLength; i++) {
      code += random[(random.length * (i / 2)).floor() % random.length];
    }
    return code;
  }
}
