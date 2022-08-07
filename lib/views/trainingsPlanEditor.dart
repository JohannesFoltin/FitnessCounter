import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TrainingsPlanEditor extends StatefulWidget {
  const TrainingsPlanEditor({Key? key, required this.trainingPlan})
      : super(key: key);

  final TrainingPlan trainingPlan;

  @override
  State<TrainingsPlanEditor> createState() => _TrainingsPlanEditorState();
}

class _TrainingsPlanEditorState extends State<TrainingsPlanEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.trainingPlan.name)),
      body: ListView.builder(
        itemCount: widget.trainingPlan.exercises.length,
        itemBuilder: (context, index) {
          return Card(
            child: Row(
              children: [
                Text(widget.trainingPlan.exercises[index].name),
                IconButton(
                    onPressed: () {
                      setState(() {
                        widget.trainingPlan.exercises.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete))
              ],
            ),
          );
        },
      ),
    );
  }

}
