import 'package:json_annotation/json_annotation.dart';

part 'wiederholung.g.dart';

@JsonSerializable()
class Rep {
  int wert;
  Rep(this.wert);

  factory Rep.fromJson(Map<String, dynamic> json) =>
      _$wiederholungFromJson(json);

  Map<String, dynamic> toJson() => _$wiederholungToJson(this);
}
