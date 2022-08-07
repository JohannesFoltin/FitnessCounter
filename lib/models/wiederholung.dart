import 'package:json_annotation/json_annotation.dart';

part 'wiederholung.g.dart';

@JsonSerializable()
class Set {
  int wert;
  int repitions;
  Set(this.wert, this.repitions);

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);

  Map<String, dynamic> toJson() => _$SetToJson(this);
}
