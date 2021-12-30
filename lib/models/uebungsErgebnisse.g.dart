// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uebungsErgebnisse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UebungsErgebnisse _$UebungsErgebnisseFromJson(Map<String, dynamic> json) =>
    UebungsErgebnisse(
      json['name'] as String,
      json['wert'] as String,
      BigInt.parse(json['dauer'] as String),
    );

Map<String, dynamic> _$UebungsErgebnisseToJson(UebungsErgebnisse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'wert': instance.wert,
      'dauer': instance.dauer.toString(),
    };
