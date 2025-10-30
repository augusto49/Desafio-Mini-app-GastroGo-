import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/presentation/pages/restaurant_detail_page.dart';
import 'package:gastrogo/presentation/providers/providers.dart';
import 'package:gastrogo/presentation/widgets/dish_tile.dart';
import 'package:gastrogo/presentation/widgets/restaurant_card.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favsAsync = ref.watch(favoritesProvider);
    final restaurantsAsync = ref.watch(restaurantsProvider);
    final dishesAsync = ref.watch(dishesProvider);

    return favsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erro: $e')),
      data: (favs) {
        if (favs.isEmpty) {
          return const Center(child: Text('Nenhum favorito ainda.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Restaurantes Favoritos ---
              const Text(
                'Restaurantes Favoritos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              restaurantsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
                data: (restaurants) {
                  final favRestaurants =
                      restaurants.where((r) => favs.contains(r.id)).toList();

                  if (favRestaurants.isEmpty) {
                    return const Text('Nenhum restaurante favoritado.');
                  }

                  return Column(
                    children:
                        favRestaurants.map((r) {
                          return RestaurantCard(
                            restaurant: r,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          RestaurantDetailPage(restaurant: r),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),

              // --- Pratos Favoritos ---
              const Text(
                'Pratos Favoritos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              dishesAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
                data: (dishes) {
                  final favDishes =
                      dishes.where((d) => favs.contains(d.id)).toList();

                  if (favDishes.isEmpty) {
                    return const Text('Nenhum prato favoritado.');
                  }

                  return restaurantsAsync.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error:
                        (_, __) => Column(
                          children:
                              favDishes.map((d) {
                                return DishTile(dish: d);
                              }).toList(),
                        ),
                    data: (restaurants) {
                      return Column(
                        children:
                            favDishes.map((d) {
                              return DishTile(
                                dish: d,
                                onTap: () {
                                  try {
                                    final rest = restaurants.firstWhere(
                                      (r) => r.id == d.restaurant_id,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => RestaurantDetailPage(
                                              restaurant: rest,
                                            ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Restaurante do prato não encontrado.',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            }).toList(),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
