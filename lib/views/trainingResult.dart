import 'dart:html';

import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';

class TrainingResult extends StatefulWidget{
  TrainingResult({Key? key, required this.appData,required this.dateCode}) : super(key: key);

  final AppData appData;
  final BigInt dateCode;

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

  @override
  _TrainingResult createState() => _TrainingResult();

}

class _TrainingResult extends State<TrainingResult>{
  late DateTime date;
  late Training training;

  @override
  void initState() {
    // training = widget.appData.trainings.firstWhere((element) => element.datumCode == widget.dateCode);
    // date = DateTime.fromMillisecondsSinceEpoch(training.datum);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Flexible(
              flex: 1,
                child: Text(TrainingResult.formatTime(training.dauer, true))
            ),
        /*    Flexible(
              flex: 3,
                child: ListView.builder(
                    itemCount: training.uebungErgebnisse.length,
                    itemBuilder: (context, index) {
                      final item = training.uebungErgebnisse[index];
                      return item.buildCard(context);
                    })
            )*/
          ],
        ),
    ));
  }
  AppBar _buildAppBar() {

    return AppBar(
      backgroundColor: HexColor.fromHex("#006666"),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text("Training am " + date.day.toString() +"."+date.month.toString()+"."+date.year.toString()),
      actions: [
        IconButton(
            onPressed: () => {
              //TODO
            },
            icon: Icon(Icons.check))
      ],
    );

  }
}
abstract class ListItem {
  Widget buildCard(BuildContext context);
}

/*class CardItem implements ListItem {
  late final AppData appData;
  late Uebung uebung;
  
  
  CardItem(AppData appData) {
  }
  */

/*  @override
  Widget buildCard(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        child: Row(
          children: [
            Text()
          ],
        ),
          color: HexColor.fromHex(uebung.color),
          ),
    );
  }*/
