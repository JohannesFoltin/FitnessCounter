import 'package:json_annotation/json_annotation.dart';
import 'package:fitness_f/models/datalayer.dart';

part 'wiederholung.g.dart';

@JsonSerializable()
class wiederholung{
  int wert;
  wiederholung(this.wert);

  factory wiederholung.fromJson(Map<String, dynamic> json) => _$wiederholungFromJson(json);

  Map<String, dynamic> toJson() => _$wiederholungToJson(this);
}