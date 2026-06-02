import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DataFire extends StatefulWidget {
  const DataFire({super.key});

  @override
  State<DataFire> createState() => _DataFire();
}

class _DataFire extends State<DataFire> {
  int _likes = 0;

  // variável que é a referência do contador de likes no firebase
  late final DatabaseReference _likesRef;

  // para receber os eventos do database em real time
  StreamSubscription<DatabaseEvent>? _likesSubscription;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    // liga _likesRef com o objeto do firebase
    _likesRef = FirebaseDatabase.instance.ref('likes');

    try {
      // armazena o valor atual de likes que está no firebase
      final likeSnapshot = await _likesRef.get();

      // atribui o valor para o contador de likes
      _likes = _toInt(likeSnapshot.value);
    } catch (err) {
      debugPrint(err.toString());
    }

    // verifica alterações no banco de dados
    _likesSubscription = _likesRef.onValue.listen((DatabaseEvent event) {
      if (!mounted) return;

      setState(() {
        _likes = _toInt(event.snapshot.value);
      });
    });
  }

  // método contador de likes
  Future<void> like() async {
    await _likesRef.set(ServerValue.increment(1));
  }

  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return 0;
  }

  @override
  void dispose() {
    _likesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Acessando Firebase")),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: like, icon: const Icon(Icons.thumb_up)),
            Text(_likes.toString(), style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
