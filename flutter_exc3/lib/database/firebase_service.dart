import 'package:firebase_database/firebase_database.dart';
import '../models/entrega.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final DatabaseReference _ref = FirebaseDatabase.instance.ref('entregas');

  Future<String> inserirEntrega(Entrega entrega) async {
    final novaRef = _ref.push();
    await novaRef.set(entrega.toJson());
    return novaRef.key!;
  }

  Stream<List<Entrega>> streamEntregas() {
    return _ref.onValue.map((DatabaseEvent event) {
      final valor = event.snapshot.value;
      if (valor == null) return <Entrega>[];

      final mapa = Map<String, dynamic>.from(valor as Map);
      final lista = mapa.entries.map((entry) {
        return Entrega.fromJson(
          Map<String, dynamic>.from(entry.value as Map),
          firebaseKey: entry.key,
        );
      }).toList();

      lista.sort((a, b) =>
          b.dataHoraAtualizacao.compareTo(a.dataHoraAtualizacao));

      return lista;
    });
  }

  Future<void> atualizarEntrega(Entrega entrega) async {
    await _ref.child(entrega.firebaseKey!).update(entrega.toJson());
  }

  Future<void> deletarEntrega(String firebaseKey) async {
    await _ref.child(firebaseKey).remove();
  }
}
