import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_atv_4/main.dart';

void main() {
  testWidgets('mostra tela inicial do app de cachorro', (tester) async {
    await tester.pumpWidget(const DogApp());

    expect(find.text('Foto de cachorro'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Buscar outra foto'), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsOneWidget);
  });
}
