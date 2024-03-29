import 'package:fitness_f/models/datalayer.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'uebungsErgebniss.g.dart';

@JsonSerializable()
class UebungsErgebniss {
  Uebung uebung;
  List<Set> sets;
  bool isChecked;

  UebungsErgebniss(this.uebung, this.sets,this.isChecked);
  factory UebungsErgebniss.fromJson(Map<String, dynamic> json) =>
      _$UebungsErgebnissFromJson(json);

  Map<String, dynamic> toJson() => _$UebungsErgebnissToJson(this);
}
