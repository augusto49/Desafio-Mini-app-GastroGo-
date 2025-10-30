// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dish_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DishModel _$DishModelFromJson(Map<String, dynamic> json) => DishModel(
  id: json['id'] as String,
  restaurant_id: json['restaurant_id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  vegan: json['vegan'] as bool,
  image_url: json['image_url'] as String,
);

Map<String, dynamic> _$DishModelToJson(DishModel instance) => <String, dynamic>{
  'id': instance.id,
  'restaurant_id': instance.restaurant_id,
  'name': instance.name,
  'price': instance.price,
  'vegan': instance.vegan,
  'image_url': instance.image_url,
};
