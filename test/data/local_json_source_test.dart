import 'package:flutter_test/flutter_test.dart';
import 'package:gastrogo/data/sources/local_json_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalJsonSource', () {
    final source = LocalJsonSource();

    test('should load restaurants JSON correctly', () async {
      final restaurants = await source.loadRestaurants();
      expect(restaurants, isNotEmpty);
      expect(restaurants.first.name, isNotEmpty);
    });

    test('should load dishes JSON correctly', () async {
      final dishes = await source.loadDishes();
      expect(dishes, isNotEmpty);
      expect(dishes.first.name, isNotEmpty);
    });
  });
}
