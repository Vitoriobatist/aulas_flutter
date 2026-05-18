import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora de IMC',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const CalculadoraIMC(),
    ),
  );
}

class CalculadoraIMC extends StatefulWidget {
  const CalculadoraIMC({super.key});

  @override
  State<CalculadoraIMC> createState() => _CalculadoraIMCState();
}

class _CalculadoraIMCState extends State<CalculadoraIMC> {
  final txtPeso = TextEditingController();
  final txtAltura = TextEditingController();

  String _resultado = '';
  String _classificacao = '';

  void _calcularIMC() {
    final peso = double.tryParse(txtPeso.text.replaceAll(',', '.'));
    final altura = double.tryParse(txtAltura.text.replaceAll(',', '.'));

    if (peso == null || altura == null || altura == 0) {
      setState(() {
        _resultado = 'Valores inválidos';
        _classificacao = '';
      });
      return;
    }

    final imc = peso / (altura * altura);

    String classificacao;
    if (imc < 18.5) {
      classificacao = 'Magreza';
    } else if (imc < 25) {
      classificacao = 'Normal';
    } else if (imc < 30) {
      classificacao = 'Sobrepeso';
    } else if (imc < 35) {
      classificacao = 'Obesidade grau I';
    } else if (imc < 40) {
      classificacao = 'Obesidade grau II';
    } else {
      classificacao = 'Obesidade grau III';
    }

    setState(() {
      _resultado = imc.toStringAsFixed(2);
      _classificacao = classificacao;
    });
  }

  void _limpar() {
    txtPeso.clear();
    txtAltura.clear();
    setState(() {
      _resultado = '';
      _classificacao = '';
    });
  }

  @override
  void dispose() {
    txtPeso.dispose();
    txtAltura.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: txtPeso,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: txtAltura,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calcularIMC,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Calcular', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _limpar,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Limpar', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_resultado.isNotEmpty)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Seu IMC',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _resultado,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _classificacao,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 32),
            const Text(
              'Tabela de Classificação',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.8),
              },
              children: const [
                TableRow(
                  decoration: BoxDecoration(color: Color(0xFF1565C0)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'IMC',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Classificação',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('Menor que 18,5')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Magreza')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('18,5 a 24,9')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Normal')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('25 a 29,9')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Sobrepeso')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('30 a 34,9')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Obesidade grau I')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('35 a 39,9')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Obesidade grau II')),
                ]),
                TableRow(children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('Maior que 40')),
                  Padding(padding: EdgeInsets.all(8), child: Text('Obesidade grau III')),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
