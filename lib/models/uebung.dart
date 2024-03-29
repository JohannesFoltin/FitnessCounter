import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'uebung.g.dart';

@JsonSerializable()
class Uebung {
  String name;
  String beschreibung;
  String pictureAsset;
  String notizen;
  String einheit;
  String typ;
  int maximum;

  Uebung(this.name, this.beschreibung, this.pictureAsset, this.typ,
      this.notizen, this.einheit,this.maximum);
  setNotizen(String notiz) {
    this.notizen = notiz;
  }

  factory Uebung.fromJson(Map<String, dynamic> json) => _$UebungFromJson(json);

  Map<String, dynamic> toJson() => _$UebungToJson(this);
}
