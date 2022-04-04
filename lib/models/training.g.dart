// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
      json['dauer'] as int,
      DateTime.parse(json['date'] as String),
      (json['uebungErgebnisse'] as List<dynamic>)
          .map((e) => UebungsErgebniss.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
      'dauer': instance.dauer,
      'date': instance.date.toIso8601String(),
      'uebungErgebnisse': instance.uebungErgebnisse,
    };
