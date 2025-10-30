import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/presentation/providers/providers.dart';

class RestaurantCard extends ConsumerWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;
  final String? heroTagSuffix;

  const RestaurantCard({
    required this.restaurant,
    this.onTap,
    this.heroTagSuffix,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoritesProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final tag = 'restaurant_${restaurant.id}${heroTagSuffix ?? ''}';

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Imagem ---
            Stack(
              children: [
                Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl: restaurant.image_url,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder:
                        (_, __) => Container(
                          height: 160,
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (_, __, ___) => Container(
                          height: 160,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.broken_image)),
                        ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: favAsync.when(
                    data: (set) {
                      final isFav = set.contains(restaurant.id);
                      return CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFav ? colorScheme.primary : Colors.grey[700],
                            size: 18,
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
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    error:
                        (_, __) => CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: const Icon(Icons.favorite_border, size: 18),
                        ),
                  ),
                ),
              ],
            ),

            // --- Detalhes ---
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.distance_km} km',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
