import 'dart:async';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/main.dart';
import 'package:fitness_f/views/uebungVisualiser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_timer/simple_timer.dart';

import '../controller/controller.dart';

class OnFitness extends StatefulWidget {
  OnFitness({Key? key, required this.trainingPlan}) : super(key: key);

  final TrainingPlan? trainingPlan;

  @override
  _OnFitness createState() => _OnFitness();

  //ToDo: Hinzufügen zum Controller
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
}

class _OnFitness extends State<OnFitness> with SingleTickerProviderStateMixin {
  bool run = true;
  Stopwatch _stopwatch = new Stopwatch();
  late Training training;
  Color buttonColor = Colors.orange;
  late TimerController _countDownController;
  late final DateTime dateCode;
  int uebungenlength = 0;
  bool isChecked = false;
  List<UebungsErgebniss> uebungenList = [];

  @override
  void initState() {
    _countDownController = TimerController(this);
    _stopwatch.start();
    dateCode = DateTime.now();
    training = new Training(0, dateCode, []);
    //TODO check for Trainingsplan and modifiy uebungenlength
    print("init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text("Zeit in der Übung"),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                height: 50,
                                color: buttonColor,
                                child: TextButton(
                                  onPressed: () => {
                                    setState(() {
                                      handleStartStop();
                                      if (buttonColor == Colors.orange) {
                                        buttonColor =
                                            HexColor.fromHex("#008060");
                                      } else {
                                        buttonColor = Colors.orange;
                                      }
                                    })
                                  },
                                  onLongPress: () => {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              title: const Text(
                                                  'Willst du das Training wirklich abbrechen?'),
                                              content: const Text(
                                                  'Alles geht verloren...'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => {
                                                    Navigator.pop(context),
                                                    Navigator.pop(context)
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                              ],
                                            )),
                                  },
                                  child: TimerField(_stopwatch, true),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Text("Pause Timer"),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                height: 50,
                                color: Colors.red,
                                child: TextButton(
                                  onPressed: () => {
                                    if (_countDownController.isAnimating)
                                      {_countDownController.stop()}
                                    else
                                      {_countDownController.start()}
                                  },
                                  onLongPress: () =>
                                      {_countDownController.reset()},
                                  child: SimpleTimer(
                                    controller: _countDownController,
                                    progressTextStyle: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                    displayProgressIndicator: false,
                                    duration: Duration(minutes: 1, seconds: 30),
                                    progressTextCountDirection:
                                        TimerProgressTextCountDirection
                                            .count_down,
                                    onEnd: () => {_countDownController.reset()},
                                  ),
                                )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: /* _buildUebungenList() */ ListView.builder(
                      itemCount: uebungenList.length,
                      itemBuilder: (context, indexCard) {
                        UebungsErgebniss uebungsErgebniss =
                            uebungenList[indexCard];
                        Uebung uebung = uebungsErgebniss.uebung;
                        return Card(
                          //TODO Color
                          // color: HexColor.fromHex(uebung.color),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  UebungVisualiser(
                                                    uebung: uebung,
                                                  ))))
                                    },
                                    style: TextButton.styleFrom(
                                      alignment: Alignment.centerLeft,
                                      primary: Colors.black,
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    child: Text(
                                      uebung.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Checkbox(
                                      value: uebungsErgebniss.isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          uebungsErgebniss.isChecked =
                                              !uebungsErgebniss.isChecked;
                                        });
                                      })
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: uebungsErgebniss.sets.length,
                                  itemBuilder: (context, indexSet) {
                                    Set set = uebungsErgebniss.sets[indexSet];
                                    return (indexSet !=
                                                uebungsErgebniss.sets.length -
                                                    1) &&
                                            (uebungsErgebniss.sets.length != 0)
                                        ? Row(
                                            children: [],
                                          )
                                        : Row(
                                            children: [
                                              Text("Set" +
                                                  (indexSet + 1).toString()),
                                              Text(set.repitions.toString() +
                                                  "x"),
                                              Text(set.wert.toString() +
                                                  uebung.einheit)
                                            ],
                                          );
                                  }),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {}, icon: Icon(Icons.add)),
                                  uebungsErgebniss.sets.length == 0
                                      ? SizedBox.shrink()
                                      : IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.delete)),
                                ],
                              )
                            ],
                          ),
                        );
                      })),
              Center(
                child: IconButton(
                    onPressed: () {
                      uebungenList.add(UebungsErgebniss(
                          Provider.of<AppDataController>(context, listen: false)
                              .appData
                              .uebungs
                              .first,
                          [],
                          false));
                      setState(() {});
                    },
                    icon: Icon(Icons.add)),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HexColor.fromHex("#006666"),
      automaticallyImplyLeading: false,
      title: Text("Training am " +
          // TODO Formatierung
          DateTime.now().day.toString() +
          "." +
          DateTime.now().month.toString() +
          "." +
          DateTime.now().year.toString()),
      actions: [
        IconButton(
            onPressed: () => {
                  _showFinishDialog(),
                },
            icon: Icon(Icons.check))
      ],
    );
  }

  Future<String?> _showFinishDialog() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: const Text('Bist du fertig mit dem Training?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {Navigator.pop(context), tot(training)},
                  child: const Text('JAAAA'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Noch nicht...'),
                ),
              ],
            ));
  }

  void tot(Training training) {
    training.dauer = _stopwatch.elapsedMilliseconds;
    Provider.of<AppDataController>(context, listen: false)
        .addTraining(training);
    Provider.of<AppDataController>(context, listen: false).saveAppData();
    Navigator.pop(context);
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      run = !run;
    } else {
      _stopwatch.start();
      run = !run;
    }
  }
}

class TimerField extends StatefulWidget {
  TimerField(this.watch, this.returnHours);

  final Stopwatch watch;
  final bool returnHours;

  TimerFieldState createState() => TimerFieldState();
}

class TimerFieldState extends State<TimerField> {
  late Timer _timer;

  @override
  void initState() {
    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.returnHours) {
      return Text(
        OnFitness.formatTime(widget.watch.elapsedMilliseconds, true),
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      );
    } else {
      return Text(
        OnFitness.formatTime(widget.watch.elapsedMilliseconds, false),
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      );
    }
  }
}
