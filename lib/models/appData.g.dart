// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppData _$AppDataFromJson(Map<String, dynamic> json) => AppData(
      (json['uebungs'] as List<dynamic>)
          .map((e) => Uebung.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['trainings'] as List<dynamic>)
          .map((e) => Training.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppDataToJson(AppData instance) => <String, dynamic>{
      'uebungs': instance.uebungs,
      'trainings': instance.trainings,
    };
