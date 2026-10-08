import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cafeteria/main.dart';

void main() {
  group('Parte 4 — Casos obligatorios del pedido', () {

  testWidgets('Sanity: los 9 keys (3 productos × 3 controles) existen',
      (tester) async {
    await tester.pumpWidget(const CafeteriaApp());

    for (final nombre in ['Café', 'Sándwich', 'Jugo']) {
      expect(find.byKey(ValueKey('dec_$nombre')), findsOneWidget,
          reason: 'Falta dec_$nombre');
      expect(find.byKey(ValueKey('cant_$nombre')), findsOneWidget,
          reason: 'Falta cant_$nombre');
      expect(find.byKey(ValueKey('inc_$nombre')), findsOneWidget,
          reason: 'Falta inc_$nombre');
    }
  });

    // ---------------------------------------------------------------
    // Caso 1 — Estado inicial: cantidades 0 y total Q0.00
    // ---------------------------------------------------------------
    testWidgets('Caso 1: inicio con cantidades en 0 y total Q0.00',
        (tester) async {
      await tester.pumpWidget(const CafeteriaApp());

      // Total inicial
      expect(find.text('Q0.00'), findsOneWidget);

      // Las tres cantidades deben mostrar "0"
      expect(find.byKey(const ValueKey('cant_Café')), findsOneWidget);
      expect(find.byKey(const ValueKey('cant_Sándwich')), findsOneWidget);
      expect(find.byKey(const ValueKey('cant_Jugo')), findsOneWidget);

      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Café'))).data,
        '0',
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Sándwich'))).data,
        '0',
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Jugo'))).data,
        '0',
      );
    });

    // ---------------------------------------------------------------
    // Caso 2 — 2 cafés + 1 sándwich + 1 jugo → Q57.00
    // ---------------------------------------------------------------
    testWidgets('Caso 2: 2 cafés + 1 sándwich + 1 jugo → Q57.00',
        (tester) async {
      await tester.pumpWidget(const CafeteriaApp());

      // 2 cafés
      await tester.tap(find.byKey(const ValueKey('inc_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Café')));
      await tester.pump();

      // 1 sándwich
      await tester.tap(find.byKey(const ValueKey('inc_Sándwich')));
      await tester.pump();

      // 1 jugo
      await tester.tap(find.byKey(const ValueKey('inc_Jugo')));
      await tester.pump();

      // Verificamos cada cantidad
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Café'))).data,
        '2',
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Sándwich'))).data,
        '1',
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Jugo'))).data,
        '1',
      );

      // Y el total
      expect(find.text('Q57.00'), findsOneWidget);
    });

    // ---------------------------------------------------------------
    // Caso 3 — Quitar 1 café (desde el estado del caso 2) → Q47.00
    // ---------------------------------------------------------------
    testWidgets('Caso 3: quitar 1 café → Q47.00', (tester) async {
      await tester.pumpWidget(const CafeteriaApp());

      // Repetimos el setup del caso 2
      await tester.tap(find.byKey(const ValueKey('inc_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Sándwich')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Jugo')));
      await tester.pump();

      expect(find.text('Q57.00'), findsOneWidget);

      // Quitamos un café
      await tester.tap(find.byKey(const ValueKey('dec_Café')));
      await tester.pump();

      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Café'))).data,
        '1',
      );
      expect(find.text('Q47.00'), findsOneWidget);
    });

    // ---------------------------------------------------------------
    // Caso 4 — Intentar restar en cero → se queda en 0
    // ---------------------------------------------------------------
    testWidgets('Caso 4: no se puede restar por debajo de 0',
        (tester) async {
      await tester.pumpWidget(const CafeteriaApp());

      // Intentamos restar 3 veces desde 0
      await tester.tap(find.byKey(const ValueKey('dec_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('dec_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('dec_Café')));
      await tester.pump();

      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Café'))).data,
        '0',
      );
      expect(find.text('Q0.00'), findsOneWidget);
    });

    // ---------------------------------------------------------------
    // Caso 5 — Vaciar pedido → todo a 0 y Q0.00
    // ---------------------------------------------------------------
    testWidgets('Caso 5: vaciar pedido reinicia cantidades y total',
        (tester) async {
      await tester.pumpWidget(const CafeteriaApp());

      // Armamos un pedido con varios productos
      await tester.tap(find.byKey(const ValueKey('inc_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Café')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Sándwich')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('inc_Jugo')));
      await tester.pump();

      expect(find.text('Q57.00'), findsOneWidget);

      // Pulsamos "Vaciar pedido"
      await tester.tap(find.text('Vaciar pedido'));
      await tester.pump();

      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Café'))).data,
        '0',
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Sándwich'))).data,
        '0',
      );
      expect(
        tester.widget<Text>(find.byKey(const ValueKey('cant_Jugo'))).data,
        '0',
      );
      expect(find.text('Q0.00'), findsOneWidget);
    });
  });
}