import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/presentation/providers/providers.dart';
import 'package:gastrogo/presentation/widgets/dish_tile.dart';

class RestaurantDetailPage extends ConsumerWidget {
  const RestaurantDetailPage({required this.restaurant, super.key});
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishesAsync = ref.watch(dishesProvider);
    final favAsync = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // --- Imagem com AppBar flutuante ---
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(6),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(6),
                child: favAsync.when(
                  data: (set) {
                    final isFav = set.contains(restaurant.id);
                    return CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.4),
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.redAccent : Colors.white,
                        ),
                        onPressed:
                            () => ref
                                .read(favoritesProvider.notifier)
                                .toggleFavorite(restaurant.id),
                      ),
                    );
                  },
                  loading:
                      () => const CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                  error:
                      (_, __) => CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.4),
                        child: IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                          onPressed:
                              () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggleFavorite(restaurant.id),
                        ),
                      ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: restaurant.image_url,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // --- Corpo principal ---
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Card com informações principais ---
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.category,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF5C00),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFB300),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            restaurant.rating.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          const Text('Avaliação'),
                          const SizedBox(width: 20),
                          const Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.distance_km.toStringAsFixed(1)} km',
                          ),
                          const SizedBox(width: 4),
                          const Text('Distância'),
                        ],
                      ),
                    ],
                  ),
                ),

                // --- Título "Cardápio" ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Cardápio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5C00),
                    ),
                  ),
                ),

                // --- Lista de pratos ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: dishesAsync.when(
                    loading:
                        () => const Center(child: CircularProgressIndicator()),
                    error:
                        (e, _) =>
                            Center(child: Text('Erro ao carregar pratos: $e')),
                    data: (allDishes) {
                      final list =
                          allDishes
                              .where((d) => d.restaurant_id == restaurant.id)
                              .toList();

                      if (list.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('Nenhum prato encontrado.'),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: list.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          return DishTile(dish: list[i]);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
