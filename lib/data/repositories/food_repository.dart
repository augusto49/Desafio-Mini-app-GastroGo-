import 'package:gastrogo/data/models/dish_model.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/data/sources/fake_remote_source.dart';

class FoodRepository {
  final FakeRemoteSource source;
  FoodRepository({required this.source});

  Future<List<RestaurantModel>> getRestaurants() => source.fetchRestaurants();
  Future<List<DishModel>> getDishes() => source.fetchDishes();

  Future<List<DishModel>> getDishesByRestaurant(String restaurantId) async {
    final dishes = await getDishes();
    return dishes.where((d) => d.restaurant_id == restaurantId).toList();
  }

  /// 🔁 Scroll infinito (repete dados quando acaba)
  Future<List<RestaurantModel>> getRestaurantsPaginated({
    required int page,
    int limit = 8,
  }) async {
    final all = await getRestaurants();
    if (all.isEmpty) return [];

    final repeated = List.generate(page * limit, (i) => all[i % all.length]);
    final start = (page - 1) * limit;
    final end = start + limit;
    return repeated.sublist(start, end);
  }
}
