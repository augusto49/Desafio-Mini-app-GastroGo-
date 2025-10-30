import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastrogo/presentation/pages/restaurants_page.dart';

void main() {
  testWidgets('renders restaurant list and search bar', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: RestaurantsPage())),
    );

    expect(find.byType(TextField), findsOneWidget); // Search bar
    await tester.pumpAndSettle();
    expect(find.byType(Card), findsWidgets); // Restaurant cards
  });
}
