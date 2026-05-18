import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exemplo Stateful Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageCount(),
    );
  }
}

//Widget StateFulWidget
class PageCount extends StatefulWidget {
  const PageCount({super.key});
//Sobrescreve o método createState, com a lógica contida na classe de estado _PageCount
  @override
  State<PageCount> createState() => _PageCount();
}

//classe State. Esta de estado pertence ao widget PageCount, ou seja, é a classe que contém a lógica de estado do widget PageCount
//Em Dart,o caracter _ é usado para indicar que a classe é privada, ou seja, só pode ser acessada dentro do arquivo onde foi definida
class _PageCount extends State<PageCount> {
  int _contador = 0;

  void _incrementaContador() {
    //no método setSate notifica o flutter que o estado do widget mudou
    //o widget deve ser reconstruido com o novo valor de _contador
    setState(() {
      _contador++;
    });
  }

  //o Widget build é responsável por construir o Widget na interface
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Contador de cliques'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Você clicou no botão ',
            ),
            Text(
              //o caracter $ é usado para apresentar o valor de uma variável
              '$_contador vezes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementaContador,
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
