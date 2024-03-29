import 'package:fitness_f/models/datalayer.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'training.g.dart';

@JsonSerializable()
class Training {
  int dauer;
  DateTime date;
  List<UebungsErgebniss> uebungErgebnisse;

  Training(this.dauer, this.date, this.uebungErgebnisse);

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingToJson(this);
}
