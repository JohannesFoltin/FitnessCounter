import 'dart:convert';

import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDataController extends ChangeNotifier {
  AppData appData = new AppData([], [], []);
  bool isloaded = false;

  AppDataController() {
    loadAppData().then((value) => {notifyListeners(), isloaded = true});
  }

  void addUebung(String name,String beschreibung,String pictureAsset,String typ,String notizen,String einheit){
    Uebung tmp = new Uebung(name, beschreibung, pictureAsset, typ, notizen, einheit, 0);
    appData.uebungs.add(tmp);
    notifyListeners();
  }

  void addTraining(Training training) {
    appData.trainings.add(training);
    notifyListeners();
  }

  void deleteTraining(Training training) {
    if (appData.trainings.contains(training)) {
      appData.trainings.remove(training);
    } else {
      print("Error! That Training doesnt Exists!");
    }
    notifyListeners();
  }

  Future<void> saveAppData() async {
    isloaded = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("1, 2, 3, 5, 8, 13, 21, 34", jsonEncode(appData));
    notifyListeners();
    isloaded = true;
    print("AppData Saved");
  }

//Wichitg! Future<void> ist wichtig für .then()
  static String formatTime(int milliseconds, bool returnHours) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    if (returnHours)
      return "$hours:$minutes:$seconds";
    else
      return "$minutes:$seconds";
  }

  Future<void> loadAppData() async {
    final prefs = await SharedPreferences.getInstance();
    appData = AppData.fromJson(jsonDecode(
        prefs.getString("1, 2, 3, 5, 8, 13, 21, 34") ??
            "{\"trainings\":[], \"uebungs\":[], \"trainingsPlans\":[]}"));
    print("loaded");
  }

  int getTrainingsThisMonth(DateTime month) {
    return appData.trainings
        .where((element) => element.date.month == month.month)
        .length;
  }

  bool isTrainingEmpty() {
    return appData.trainings.isEmpty;
  }

}
