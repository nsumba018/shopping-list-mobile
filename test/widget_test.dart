import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/main.dart';

void main() {
  testWidgets('starts with three items and 3 left', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Bread'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Shopping List (3 left)'), findsOneWidget);
  });

  testWidgets('adds an item and clears the field', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await tester.enterText(find.byType(TextField), 'Eggs');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Eggs'), findsOneWidget);
    expect(find.text('Shopping List (4 left)'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '');
  });

  testWidgets('refuses an empty item', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Type an item first'), findsOneWidget);
    expect(find.text('Shopping List (3 left)'), findsOneWidget);
  });

  testWidgets('refuses a duplicate', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await tester.enterText(find.byType(TextField), 'Milk');
    await tester.tap(find.text('Add'));
    await tester.pump();
    expect(find.text('Milk is already on the list'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('tap marks bought, tap again undoes', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await tester.tap(find.text('Milk'));
    await tester.pump();
    expect(find.text('Shopping List (2 left)'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(tester.widget<Text>(find.text('Milk')).style!.decoration,
        TextDecoration.lineThrough);
    await tester.tap(find.text('Milk'));
    await tester.pump();
    expect(find.text('Shopping List (3 left)'), findsOneWidget);
  });

  testWidgets('bin deletes only that row', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await tester.tap(find.byIcon(Icons.delete_outline).at(1));
    await tester.pump();
    expect(find.text('Bread'), findsNothing);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Bread removed'), findsOneWidget);
  });

  testWidgets('top bar button removes bought items', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    await tester.tap(find.text('Rice'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.cleaning_services_outlined));
    await tester.pump();
    expect(find.text('Rice'), findsNothing);
    expect(find.text('Milk'), findsOneWidget);
  });

  testWidgets('shows empty message when list is empty', (tester) async {
    await tester.pumpWidget(const ShoppingApp());
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pump();
    }
    expect(find.text('Your list is empty'), findsOneWidget);
  });
}
