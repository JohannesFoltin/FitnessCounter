// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uebung.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uebung _$UebungFromJson(Map<String, dynamic> json) => Uebung(
      json['name'] as String,
      json['beschreibung'] as String,
      json['pictureAsset'] as String,
      json['typ'] as String,
      json['notizen'] as String,
      json['einheit'] as String,
      json['maximum'] as int,
    );

Map<String, dynamic> _$UebungToJson(Uebung instance) => <String, dynamic>{
      'name': instance.name,
      'beschreibung': instance.beschreibung,
      'pictureAsset': instance.pictureAsset,
      'notizen': instance.notizen,
      'einheit': instance.einheit,
      'typ': instance.typ,
      'maximum': instance.maximum,
    };
