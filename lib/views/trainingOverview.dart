import 'package:flutter/material.dart';
import 'package:fitness_f/views/trainingResult.dart';
import 'package:provider/provider.dart';
import '../controller/controller.dart';

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
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: Provider.of<AppDataController>(context, listen: false)
              .appData
              .trainings
              .length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 50,
                width: 100,
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: ElevatedButton(
                  child: Text(
                    "Training am :" +
                        Provider.of<AppDataController>(context, listen: false)
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
                                training: Provider.of<AppDataController>(
                                        context,
                                        listen: false)
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
