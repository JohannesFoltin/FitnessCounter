// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
      json['dauer'] as int,
      dateCode.fromJson(json['date'] as Map<String, dynamic>),
      (json['uebungErgebnisse'] as List<dynamic>)
          .map((e) => UebungsErgebniss.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
      'dauer': instance.dauer,
      'date': instance.date,
      'uebungErgebnisse': instance.uebungErgebnisse,
    };
