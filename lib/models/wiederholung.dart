import 'package:json_annotation/json_annotation.dart';

part 'wiederholung.g.dart';

@JsonSerializable()
class Rep {
  int wert;
  Rep(this.wert);

  factory Rep.fromJson(Map<String, dynamic> json) => _$RepFromJson(json);

  Map<String, dynamic> toJson() => _$RepToJson(this);
}
