import 'package:flutter/cupertino.dart';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/appData_provider.dart';
import 'package:flutter/material.dart';

class TrainingOverview extends StatefulWidget {
  TrainingOverview({Key? key}) : super(key: key);

  @override
  _TrainingOverview createState() => _TrainingOverview();
}

class _TrainingOverview extends State<TrainingOverview> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: ListView.builder(
              itemCount: AppDataProvider.of(context).appData.trainings.length,
              itemBuilder: (BuildContext context,int index) {
                return Container(child: Text("Hello Motherfuckers"),);
              },),
        ),
      ),
    );
  }
}
