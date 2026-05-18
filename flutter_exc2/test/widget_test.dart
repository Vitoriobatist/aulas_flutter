import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_exc2/main.dart';

void main() {
  testWidgets('faz login com credenciais validas', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(EditableText).at(0), 'aula');
    await tester.enterText(find.byType(EditableText).at(1), '123');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo!'), findsOneWidget);
  });

  testWidgets('mostra erro com credenciais invalidas', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.enterText(find.byType(EditableText).at(0), 'aula');
    await tester.enterText(find.byType(EditableText).at(1), 'senha errada');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Login ou senha incorretos!'), findsOneWidget);
  });
}
