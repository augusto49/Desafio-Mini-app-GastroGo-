import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gastrogo/data/models/dish_model.dart';
import 'package:gastrogo/data/models/restaurant_model.dart';

class LocalJsonSource {
  Future<List<RestaurantModel>> loadRestaurants() async {
    final jsonStr = await rootBundle.loadString('assets/restaurants.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    return list
        .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<DishModel>> loadDishes() async {
    final jsonStr = await rootBundle.loadString('assets/dishes.json');
    final list = json.decode(jsonStr) as List<dynamic>;
    return list
        .map((e) => DishModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
