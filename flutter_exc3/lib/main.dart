// lib/main.dart

import 'package:flutter/material.dart';
import 'database/database_initializer.dart';
import 'screens/lista_entregas_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabaseFactory();
  runApp(const EntregasApp());
}

class EntregasApp extends StatelessWidget {
  const EntregasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Entregas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ListaEntregasScreen(),
    );
  }
}
