import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart';

void main() {
  testWidgets('Dashboard DGI affiche correctement', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Vérifie que le logo DGI est présent
    expect(find.byType(Image), findsWidgets);

    // Vérifie que les cartes de statistiques sont présentes
    expect(find.text('Contribuables'), findsOneWidget);
    expect(find.text('Relances'), findsOneWidget);
    expect(find.text('Paiements'), findsOneWidget);
    expect(find.text('Agents'), findsOneWidget);

    // Vérifie le texte de bienvenue
    expect(find.textContaining('Bienvenue'), findsOneWidget);

    // Vérifie le Drawer et les ListTile
    final ScaffoldState scaffoldState = tester.firstState(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Contribuables'), findsOneWidget);
    expect(find.text('Déclarations'), findsOneWidget);
    expect(find.text('Relances'), findsOneWidget);
    expect(find.text('Paiements'), findsOneWidget);
    expect(find.text('Agents'), findsOneWidget);
    expect(find.text('Historique'), findsOneWidget);
  });
}
