import 'package:fitness_f/views/appData_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitness_f/views/trainingResult.dart';

class TrainingOverview extends StatefulWidget {
  TrainingOverview({Key? key}) : super(key: key);

  @override
  _TrainingOverview createState() => _TrainingOverview();
}

class _TrainingOverview extends State<TrainingOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tranings Übersicht"),
        actions: [
          IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Icon(Icons.arrow_back))
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: AppDataProvider.of(context).appData.trainings.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 50,
                width: 100,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: ElevatedButton(
                  child: Text(
                    "Training am :" +
                        AppDataProvider.of(context)
                            .appData
                            .trainings[index]
                            .date
                            .toString(),
                  ),
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrainingResult(
                                training: AppDataProvider.of(context)
                                    .appData
                                    .trainings[index])))
                  },
                ));
          },
        ),
      ),
    );
  }
}
