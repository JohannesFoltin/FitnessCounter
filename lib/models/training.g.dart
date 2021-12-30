// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
      BigInt.parse(json['dauer'] as String),
      BigInt.parse(json['datum'] as String),
      (json['uebungErgebnisse'] as List<dynamic>)
          .map((e) => UebungsErgebnisse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
      'dauer': instance.dauer.toString(),
      'datum': instance.datum.toString(),
      'uebungErgebnisse': instance.uebungErgebnisse,
    };
