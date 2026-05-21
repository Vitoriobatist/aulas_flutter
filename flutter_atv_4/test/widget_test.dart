import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_atv_4/main.dart';

void main() {
  testWidgets('mostra tela inicial com foto e gif', (tester) async {
    await tester.pumpWidget(const DogApp());

    expect(find.text('Chorros Bonitos'), findsOneWidget);
    expect(find.text('Foto'), findsOneWidget);
    expect(find.text('GIF'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Buscar outra foto'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Buscar outro GIF'), findsOneWidget);
    expect(find.byIcon(Icons.pets), findsOneWidget);
    expect(find.byIcon(Icons.gif_box), findsOneWidget);
  });
}
