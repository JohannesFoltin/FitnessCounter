import 'dart:convert';

import 'package:fitness_f/models/datalayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataController {
  late AppData appData = new AppData([], []);

  
  void addTraining(Training training){
    appData.trainings.add(training);
  }
  
  void deleteTraining(Training training){
    if(appData.trainings.contains(training)){
      appData.trainings.remove(training);
    }
    else{
      print("Error! That Training doesnt Exists!");
    }
  }

}