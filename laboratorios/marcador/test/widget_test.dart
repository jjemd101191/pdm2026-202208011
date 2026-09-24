import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:marcador/main.dart';

void main() {
  testWidgets('Inicia en 0-0 mostrando Empate', (WidgetTester tester) async {
    await tester.pumpWidget(const MarcadorApp());

    expect(find.text('Marcador Deportivo'), findsOneWidget);
    expect(find.text('Equipo A'), findsOneWidget);
    expect(find.text('Equipo B'), findsOneWidget);
    expect(find.text('0'), findsNWidgets(2));
    expect(find.text('Empate'), findsOneWidget);
  });

  testWidgets('+1 de Equipo A suma y muestra ventaja de A',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MarcadorApp());

    await tester.tap(find.widgetWithText(FilledButton, '+1').first);
    await tester.pump();

    expect(find.text('1'), findsOneWidget);
    expect(find.text('Va ganando Equipo A'), findsOneWidget);
  });

  testWidgets('Ventaja de B se muestra como ganadora',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MarcadorApp());

    await tester.tap(find.widgetWithText(FilledButton, '+1').last);
    await tester.pump();

    expect(find.text('Va ganando Equipo B'), findsOneWidget);
  });

  testWidgets('El marcador no baja de cero', (WidgetTester tester) async {
    await tester.pumpWidget(const MarcadorApp());

    await tester.tap(find.widgetWithText(OutlinedButton, '-1').first);
    await tester.pump();

    expect(find.text('0'), findsNWidgets(2));
  });

  testWidgets('Reiniciar vuelve a 0-0 con Empate', (WidgetTester tester) async {
    await tester.pumpWidget(const MarcadorApp());

    await tester.tap(find.widgetWithText(FilledButton, '+1').last);
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, '+1').last);
    await tester.pump();

    expect(find.text('Va ganando Equipo B'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Reiniciar'));
    await tester.pump();

    expect(find.text('0'), findsNWidgets(2));
    expect(find.text('Empate'), findsOneWidget);
  });
}