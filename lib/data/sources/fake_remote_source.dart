import 'dart:async';
import 'dart:math';

import 'package:gastrogo/data/models/dish_model.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';
import 'package:gastrogo/data/sources/local_json_source.dart';

/// Simula um servidor remoto, com delay e falhas limitadas (1 ou 2 por ciclo)
class FakeRemoteSource {
  FakeRemoteSource(this.local);
  final LocalJsonSource local;
  final _random = Random();

  // Contadores de falhas (resetam depois de algumas chamadas)
  int _restaurantFailures = 0;
  int _dishFailures = 0;

  /// Simula um fetch remoto de restaurantes
  Future<List<RestaurantModel>> fetchRestaurants() async {
    await Future.delayed(const Duration(seconds: 2));

    // Até 2 falhas simuladas no total
    if (_restaurantFailures < 2 && _random.nextDouble() < 0.3) {
      _restaurantFailures++;
      throw Exception(
        'Erro ao buscar restaurantes (falha simulada $_restaurantFailures)',
      );
    }

    // Após sucesso, zera contador
    _restaurantFailures = 0;
    return local.loadRestaurants();
  }

  /// Simula um fetch remoto de pratos
  Future<List<DishModel>> fetchDishes() async {
    await Future.delayed(const Duration(seconds: 1));

    // Até 1 falha simulada no total
    if (_dishFailures < 1 && _random.nextDouble() < 0.25) {
      _dishFailures++;
      throw Exception('Erro ao buscar pratos (falha simulada $_dishFailures)');
    }

    _dishFailures = 0;
    return local.loadDishes();
  }
}
