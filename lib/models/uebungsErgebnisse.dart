import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'uebungsErgebnisse.g.dart';

@JsonSerializable()
class UebungsErgebnisse{
  String name;
  String wert;
  BigInt dauer;

  UebungsErgebnisse(this.name,this.wert,this.dauer);
  factory UebungsErgebnisse.fromJson(Map<String, dynamic> json) => _$UebungsErgebnisseFromJson(json);

  Map<String, dynamic> toJson() => _$UebungsErgebnisseToJson(this);
}