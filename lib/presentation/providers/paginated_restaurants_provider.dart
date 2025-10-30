import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/presentation/providers/providers.dart';

class PaginatedRestaurantsNotifier
    extends AsyncNotifier<List<RestaurantModel>> {
  static const int _limit = 8;

  @override
  FutureOr<List<RestaurantModel>> build() async {
    final repo = ref.read(foodRepoProvider);
    final data = await repo.getRestaurantsPaginated(page: 1, limit: _limit);
    return data;
  }

  bool get hasMore => true;

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repo = ref.read(foodRepoProvider);
    final data = await repo.getRestaurantsPaginated(page: 1, limit: _limit);
    state = AsyncValue.data(data);
  }

  void loadMore() {}
}

final paginatedRestaurantsProvider =
    AsyncNotifierProvider<PaginatedRestaurantsNotifier, List<RestaurantModel>>(
      () => PaginatedRestaurantsNotifier(),
    );
