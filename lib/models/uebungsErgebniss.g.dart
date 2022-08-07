// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uebungsErgebniss.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UebungsErgebniss _$UebungsErgebnissFromJson(Map<String, dynamic> json) =>
    UebungsErgebniss(
      Uebung.fromJson(json['uebung'] as Map<String, dynamic>),
      (json['sets'] as List<dynamic>)
          .map((e) => Set.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['isChecked'] as bool,
    );

Map<String, dynamic> _$UebungsErgebnissToJson(UebungsErgebniss instance) =>
    <String, dynamic>{
      'uebung': instance.uebung,
      'sets': instance.sets,
      'isChecked': instance.isChecked,
    };
