import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/data/models/dish_model.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/data/repositories/food_repository.dart';
import 'package:gastrogo/data/sources/fake_remote_source.dart';
import 'package:gastrogo/data/sources/local_json_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Fonte local
final localJsonSourceProvider = Provider((ref) => LocalJsonSource());

/// Simulação remota com delay e falhas
final fakeRemoteSourceProvider = Provider(
  (ref) => FakeRemoteSource(ref.read(localJsonSourceProvider)),
);

/// Repositório
final foodRepoProvider = Provider(
  (ref) => FoodRepository(source: ref.read(fakeRemoteSourceProvider)),
);

/// Restaurantes assíncronos
final restaurantsProvider = FutureProvider.autoDispose<List<RestaurantModel>>((
  ref,
) async {
  final repo = ref.read(foodRepoProvider);
  return repo.getRestaurants();
});

/// Pratos assíncronos
final dishesProvider = FutureProvider.autoDispose<List<DishModel>>((ref) async {
  final repo = ref.read(foodRepoProvider);
  return repo.getDishes();
});

/// Favoritos com SharedPreferences
class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  @override
  FutureOr<Set<String>> build() async {
    final sp = await SharedPreferences.getInstance();
    final jsonStr = sp.getString('favorites') ?? '[]';
    final decoded = json.decode(jsonStr) as List<dynamic>;
    return List<String>.from(decoded).toSet();
  }

  Future<void> toggleFavorite(String id) async {
    final current = state.valueOrNull ?? <String>{};
    final mut = Set<String>.from(current);

    if (mut.contains(id)) {
      mut.remove(id);
    } else {
      mut.add(id);
    }

    final sp = await SharedPreferences.getInstance();
    await sp.setString('favorites', json.encode(mut.toList()));
    state = AsyncValue.data(mut);
  }
}

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<String>>(
  FavoritesNotifier.new,
);
