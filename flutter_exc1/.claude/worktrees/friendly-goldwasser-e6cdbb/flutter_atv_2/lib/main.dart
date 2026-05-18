import "package:flutter/material.dart";

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Combustivel(),
      theme: ThemeData(
        hintColor: Colors.green,
        primaryColor: Colors.white,
      ),
    ),
  );
}

class Combustivel extends StatefulWidget {
  const Combustivel({super.key});

  @override
  State<Combustivel> createState() => _Combustivel();
}

class _Combustivel extends State<Combustivel> {
  // Controllers para os campos de texto
  final txtEtanol = TextEditingController();
  final txtGasolina = TextEditingController();

  // Preços fornecidos pelo usuário
  late double precoGasolina;
  late double precoEtanol;

  // Resultado do melhor combustível
  String _result = ' ';

  // Proporção de 70% para comparação entre etanol e gasolina
  double proporcao = 0;

  void _verificaCombustivel() {
    precoGasolina = double.parse(txtGasolina.text);
    precoEtanol = double.parse(txtEtanol.text);

    // Calcula 70% do preço da gasolina
    proporcao = precoGasolina * 0.7;

    setState(() {
      _result = precoEtanol <= proporcao ? 'Etanol' : 'Gasolina';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Com que abastecer?'),
      ),
      body: Column(
        children: [
          // Campo: preço do etanol
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: txtEtanol,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preço do Etanol',
              ),
            ),
          ),

          // Campo: preço da gasolina
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: txtGasolina,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Preço da Gasolina',
              ),
            ),
          ),

          // Botão de verificação
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _verificaCombustivel,
              child: const Text('Verificar'),
            ),
          ),

          // Resultado
          Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text('O melhor combustível é $_result'),
          ),
        ],
      ),
    );
  }
}