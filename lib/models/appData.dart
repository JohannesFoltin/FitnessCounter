import 'package:fitness_f/models/datalayer.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'appData.g.dart';

// Falls Probleme: run command: flutter pub run build_runner build
// Wenn nicht dann: flutter pub run build_runner watch

/*
Wenn neue Klasse:
factory AppData.fromJson(Map<String, dynamic> json) => _$AppDataFromJson(json);
Map<String, dynamic> toJson() => _$AppDataToJson(this);
 */

@JsonSerializable()
class AppData{

  List<Uebung> uebungs;
  List<Training> trainings;

  AppData(this.uebungs,this.trainings);
  Uebung getUebungByName(String name){
    return uebungs.firstWhere((element) => element.name == name);
  }
  List<Uebung> getUebungs(){
    return uebungs;
  }
  factory AppData.fromJson(Map<String, dynamic> json) => _$AppDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppDataToJson(this);
}