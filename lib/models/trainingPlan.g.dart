// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainingPlan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingPlan _$TrainingPlanFromJson(Map<String, dynamic> json) => TrainingPlan(
      json['name'] as String,
      (json['exercises'] as List<dynamic>)
          .map((e) => Uebung.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingPlanToJson(TrainingPlan instance) =>
    <String, dynamic>{
      'name': instance.name,
      'exercises': instance.exercises,
    };
