// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:entregas_app/models/entrega.dart';

void main() {
  test('cria entrega a partir do mapa do SQLite', () {
    final entrega = Entrega.fromMap({
      'id': 1,
      'codigo': 'ENT-001',
      'destinatario': 'Joao',
      'endereco': 'Rua A',
      'status': 'Pendente',
      'latitude': 0,
      'longitude': -46.5,
      'dataHoraAtualizacao': '25/05/2026 10:00',
    });

    expect(entrega.id, 1);
    expect(entrega.codigo, 'ENT-001');
    expect(entrega.latitude, 0.0);
    expect(entrega.longitude, -46.5);
  });
}
