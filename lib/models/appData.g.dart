// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppData _$AppDataFromJson(Map<String, dynamic> json) => AppData(
      (json['trainings'] as List<dynamic>)
          .map((e) => Training.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['trainingsPlans'] as List<dynamic>)
          .map((e) => TrainingPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['uebungs'] as List<dynamic>)
          .map((e) => Uebung.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppDataToJson(AppData instance) => <String, dynamic>{
      'trainings': instance.trainings,
      'uebungs': instance.uebungs,
      'trainingsPlans': instance.trainingsPlans,
    };
