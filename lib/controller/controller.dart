import 'package:fitness_f/models/datalayer.dart';

class AppDataController {
  late AppData appData = new AppData([], []);

  void addTraining(Training training) {
    appData.trainings.add(training);
  }

  void deleteTraining(Training training) {
    if (appData.trainings.contains(training)) {
      appData.trainings.remove(training);
    } else {
      print("Error! That Training doesnt Exists!");
    }
  }

  int getTrainingsThisMonth(DateTime month) {
    return appData.trainings
        .where((element) => element.date.month == month.month)
        .length;
  }


}
