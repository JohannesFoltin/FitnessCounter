import 'datalayer.dart';
import 'package:json_annotation/json_annotation.dart';
part 'trainingPlan.g.dart';

@JsonSerializable()
class TrainingPlan{
  String name;
  List<Uebung> exercises;

  TrainingPlan(this.name,this.exercises);
  factory TrainingPlan.fromJson(Map<String, dynamic> json) => _$TrainingPlanFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingPlanToJson(this);
}