import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class TrainingResult extends StatefulWidget {
  TrainingResult({Key? key, required this.training})
      : super(key: key);

  final Training training;

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

class _TrainingResult extends State<TrainingResult> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async=>false,
      child: SafeArea(
          child: Scaffold(
        appBar: _buildAppBar(),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        color: Colors.red,
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Dauer:"),
                            Text(TrainingResult.formatTime(
                                widget.training.dauer, true)),
                          ],
                        ))),
                Container(
                  child: ClipRRect(
                    child: Container(
                      height: 100,
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Gesamt bewegtes Gewicht: "  /*Todo*/),
                          Text("Absolvierte Übungen: " + widget.training.uebungErgebnisse.length.toString())
                        ],
                      ),
                  ),
                ),),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: widget.training.uebungErgebnisse.length,
                    itemBuilder: (context, index) {
                      final item = widget.training.uebungErgebnisse[index];
                      return Uebungsresult(item).buildCard(context);
                    }))
          ],
        ),
      )),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HexColor.fromHex("#006666"),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text("Training am " +
          widget.training.date.day.toString() +
          "." +
          widget.training.date.month.toString() +
          "." +
          widget.training.date.year.toString()+
          " um "+
          widget.training.date.hour.toString()+
          ":"+
          widget.training.date.minute.toString()),
      actions: [
        IconButton(
            onPressed: () => {
                 Navigator.pop(context)
                },
            icon: Icon(Icons.check))
      ],
    );
  }
}

abstract class ListItem {
  Widget buildCard(BuildContext context);
}

class Uebungsresult implements ListItem {
  final UebungsErgebniss uebungsErgebniss;

  Uebungsresult(this.uebungsErgebniss);

  @override
  Widget buildCard(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          Text(uebungsErgebniss.name),
          Expanded(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: uebungsErgebniss.repetitions.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      children: [
                        Text((index + 1).toString() + "x"),
                        Text(
                            uebungsErgebniss.repetitions[index].wert.toString())
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
