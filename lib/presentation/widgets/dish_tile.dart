import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/data/models/dish_model.dart';
import 'package:gastrogo/presentation/providers/providers.dart';

class DishTile extends ConsumerWidget {
  const DishTile({required this.dish, this.onTap, super.key});
  final DishModel dish;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favAsync = ref.watch(favoritesProvider);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: SizedBox(
          width: 64,
          height: 56,
          child: CachedNetworkImage(
            imageUrl: dish.image_url,
            fit: BoxFit.cover,
            placeholder:
                (c, _) => const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                ),
            errorWidget: (c, _, __) => const Icon(Icons.broken_image),
          ),
        ),
        title: Text(dish.name),
        subtitle: Text(
          'R\$ ${dish.price.toStringAsFixed(2)} • ${dish.vegan ? "Vegano" : "Não vegano"}',
        ),
        trailing: favAsync.when(
          data: (set) {
            final isFav = set.contains(dish.id);
            return IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
              onPressed:
                  () => ref
                      .read(favoritesProvider.notifier)
                      .toggleFavorite(dish.id),
              tooltip: isFav ? 'Remover favorito' : 'Favoritar prato',
            );
          },
          loading:
              () => const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
          error:
              (_, __) => IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed:
                    () => ref
                        .read(favoritesProvider.notifier)
                        .toggleFavorite(dish.id),
              ),
        ),
      ),
    );
  }
}
