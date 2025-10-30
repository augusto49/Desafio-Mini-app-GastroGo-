import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gastrogo/presentation/pages/restaurant_detail_page.dart';
import 'package:gastrogo/presentation/providers/paginated_restaurants_provider.dart';
import 'package:gastrogo/presentation/widgets/restaurant_card.dart';

class RestaurantsPage extends ConsumerStatefulWidget {
  const RestaurantsPage({super.key});

  @override
  ConsumerState<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends ConsumerState<RestaurantsPage> {
  final ScrollController _scrollController = ScrollController();

  String query = '';
  String category = 'All';
  String sortBy = 'rating';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isInfiniteMode =>
      category == 'All' && query.isEmpty; // modo scroll infinito visual

  @override
  Widget build(BuildContext context) {
    final asyncRestaurants = ref.watch(paginatedRestaurantsProvider);
    final notifier = ref.read(paginatedRestaurantsProvider.notifier);
    final color = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        _buildFilters(context, color),
        Expanded(
          child: asyncRestaurants.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Erro ao carregar: $e')),
            data: (restaurants) {
              // --- Aplica filtros ---
              var filtered =
                  restaurants
                      .where(
                        (r) =>
                            r.name.toLowerCase().contains(query.toLowerCase()),
                      )
                      .toList();

              if (category != 'All') {
                filtered =
                    filtered.where((r) => r.category == category).toList();
              }

              // --- Aplica ordenação ---
              if (sortBy == 'rating') {
                filtered.sort((a, b) => b.rating.compareTo(a.rating));
              } else {
                filtered.sort((a, b) => a.distance_km.compareTo(b.distance_km));
              }

              if (filtered.isEmpty) {
                return const Center(
                  child: Text('Nenhum restaurante encontrado.'),
                );
              }

              // --- Define modo ---
              final isInfinite = _isInfiniteMode;

              return RefreshIndicator(
                onRefresh: () => notifier.refresh(),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      isInfinite
                          ? 1000000 // loop visual
                          : filtered.length, // lista real quando filtrado
                  itemBuilder: (context, index) {
                    final r =
                        isInfinite
                            ? filtered[index % filtered.length]
                            : filtered[index];

                    return RestaurantCard(
                      restaurant: r,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailPage(restaurant: r),
                          ),
                        );
                      },
                      heroTagSuffix: '_list',
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- Filtros de busca e categoria ---
  Widget _buildFilters(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                hintText: 'Buscar restaurantes...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () => _openFilterModal(context),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String localCategory = category;
        String localSort = sortBy;

        return StatefulBuilder(
          builder: (ctx2, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  const Text('Categoria'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children:
                        [
                              'All',
                              'Japonesa',
                              'Italiana',
                              'Brasileira',
                              'Saudável',
                              'Mexicana',
                              'Francesa',
                              'Árabe',
                            ]
                            .map(
                              (c) => ChoiceChip(
                                label: Text(c),
                                selected: localCategory == c,
                                onSelected: (sel) {
                                  setModalState(() => localCategory = c);
                                },
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 12),
                  const Text('Ordenar por'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Rating'),
                          value: 'rating',
                          groupValue: localSort,
                          onChanged:
                              (v) => setModalState(
                                () => localSort = v ?? 'rating',
                              ),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Distância'),
                          value: 'distance',
                          groupValue: localSort,
                          onChanged:
                              (v) => setModalState(
                                () => localSort = v ?? 'distance',
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancelar'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            category = localCategory;
                            sortBy = localSort;
                          });
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Aplicar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
