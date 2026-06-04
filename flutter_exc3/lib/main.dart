import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/database_initializer.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabaseFactory();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase não disponível nesta plataforma: $e');
  }
  runApp(const EntregasApp());
}

class EntregasApp extends StatelessWidget {
  const EntregasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ultra Delivery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}
