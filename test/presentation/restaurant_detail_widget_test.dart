import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/presentation/pages/restaurant_detail_page.dart';

void main() {
  testWidgets('renders restaurant detail page', (WidgetTester tester) async {
    var restaurant = RestaurantModel(
      id: 'r1',
      name: 'Sabor Mineiro',
      category: 'Brasileira',
      rating: 4.5,
      distance_km: 2.3,
      image_url: 'https://picsum.photos/seed/r1/800/400',
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: RestaurantDetailPage(restaurant: restaurant)),
      ),
    );

    expect(find.text('Sabor Mineiro'), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
  });
}
