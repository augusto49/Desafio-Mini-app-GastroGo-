import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastrogo/presentation/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavoritesNotifier', () {
    test('should toggle favorites correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      final notifier = container.read(favoritesProvider.notifier);

      await notifier.toggleFavorite('r1');
      final favorites1 = container.read(favoritesProvider).value!;
      expect(favorites1.contains('r1'), true);

      await notifier.toggleFavorite('r1');
      final favorites2 = container.read(favoritesProvider).value!;
      expect(favorites2.contains('r1'), false);
    });
  });
}
