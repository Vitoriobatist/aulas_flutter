import 'package:flutter/material.dart';

// para realizar as requisições http
import 'package:http/http.dart' as http;

// para converter os valores da API para mapas (notações JSON)
// manipuláveis pelo Dart
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData(
        hintColor: Colors.green,
        primaryColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
    ),
  );
}

// função que acessa a API
// Future indica um retorno futuro
Future<Map<String, dynamic>> getData() async {
  final request = Uri.parse(
    'https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL',
  );

  // aguarda a resposta do servidor da API e armazena em response
  final response = await http.get(request);

  if (response.statusCode != 200) {
    throw Exception('Erro ao buscar dados: ${response.statusCode}');
  }

  return json.decode(response.body) as Map<String, dynamic>;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controladores para armazenar os valores das moedas fornecidos.
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late final Future<Map<String, dynamic>> _cotacoesFuture;
  double dolar = 0.0; // armazena o valor do dolar retornado pela API
  double euro = 0.0; // armazena o valor do euro retornado pela API

  @override
  void initState() {
    super.initState();
    _cotacoesFuture = getData();
  }

  @override
  void dispose() {
    realController.dispose();
    dolarController.dispose();
    euroController.dispose();
    super.dispose();
  }

  // método para limpar os 3 campos
  void _clearAll() {
    realController.clear();
    dolarController.clear();
    euroController.clear();
  }

  double? _parseValue(String text) {
    return double.tryParse(text.replaceAll(',', '.'));
  }

  // método para alteração do valor em Real
  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    final real = _parseValue(text);
    if (real == null) {
      return;
    }

    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  // método para alteração do valor em Dolar
  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    final dolarValue = _parseValue(text);
    if (dolarValue == null) {
      return;
    }

    realController.text = (dolarValue * dolar).toStringAsFixed(2);
    euroController.text = (dolarValue * dolar / euro).toStringAsFixed(2);
  }

  // método para alteração do valor em Euro
  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }

    final euroValue = _parseValue(text);
    if (euroValue == null) {
      return;
    }

    realController.text = (euroValue * euro).toStringAsFixed(2);
    dolarController.text = (euroValue * euro / dolar).toStringAsFixed(2);
  }

  // método Build do Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Conversor de moeda'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      // Monta o body assim que os dados chegarem da API (FutureBuilder).
      body: FutureBuilder<Map<String, dynamic>>(
        future: _cotacoesFuture,
        // snapshot se refere à conexão com a API.
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Aguarde...',
                  style: TextStyle(color: Colors.green, fontSize: 30.0),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Ops, houve uma falha ao buscar os dados',
                    style: TextStyle(color: Colors.green, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              dolar = double.parse(snapshot.data!['USDBRL']['high'] as String);
              euro = double.parse(snapshot.data!['EURBRL']['high'] as String);

              // retorna um Widget com rolagem de tela
              return SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Icon(
                      Icons.attach_money,
                      size: 180.0,
                      color: Colors.green,
                    ),
                    buildTextField(
                      'Reais',
                      'R\$ ',
                      realController,
                      _realChanged,
                    ),
                    const Divider(),
                    buildTextField(
                      'Euros',
                      'EUR ',
                      euroController,
                      _euroChanged,
                    ),
                    const Divider(),
                    buildTextField(
                      'Dolares',
                      'US\$ ',
                      dolarController,
                      _dolarChanged,
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

// método para construir as caixas de texto
Widget buildTextField(
  String label,
  String prefix,
  TextEditingController controller,
  ValueChanged<String> onChanged,
) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.green),
      border: const OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: const TextStyle(color: Colors.green, fontSize: 25.0),
    onChanged: onChanged,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
  );
}
