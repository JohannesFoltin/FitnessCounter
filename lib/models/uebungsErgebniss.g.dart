// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uebungsErgebniss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UebungsErgebniss _$UebungsErgebnissFromJson(Map<String, dynamic> json) =>
    UebungsErgebniss(
      json['name'] as String,
      (json['repetitions'] as List<dynamic>)
          .map((e) => Rep.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['dauer'] as int,
    );

Map<String, dynamic> _$UebungsErgebnissToJson(UebungsErgebniss instance) =>
    <String, dynamic>{
      'name': instance.name,
      'dauer': instance.dauer,
      'repetitions': instance.repetitions,
    };
