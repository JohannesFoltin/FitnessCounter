import 'dart:async';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/showTimer.dart';
import 'package:fitness_f/views/ticker.dart';
import 'package:fitness_f/views/uebungSelector.dart';
import 'package:fitness_f/views/uebungVisualiser.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
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

class _OnFitness extends State<OnFitness> {
  bool run = true;
  late Training training;
  Color buttonColor = Colors.orange;
  late TimerController _countDownController;
  late final DateTime dateCode;
  late List<UebungsErgebniss> uebungenList = training.uebungErgebnisse;

  @override
  void initState() {
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
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          Text("Zeit im Training"),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                height: 50,
                                color: buttonColor,
                                child: TextButton(
                                  onPressed: () => {
                                    setState(() {
                                      if (buttonColor == Colors.orange) {
                                        buttonColor = Colors.green;
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
                                  child: Center(
                                      child: ShowTimer(starttime: 0),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          Text("Pause Timer"),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                                height: 50,
                                color: Colors.red,
                                child: ShowTimer(starttime: 90,),
                          ),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: uebungenList.length,
                      itemBuilder: (context, indexCard) {
                        UebungsErgebniss uebungsErgebniss =
                            uebungenList[indexCard];
                        Uebung uebung = uebungsErgebniss.uebung;
                        return Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Card(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: TextButton(
                                          onPressed: uebungsErgebniss.isChecked
                                              ? () {}
                                              : () => {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                UebungVisualiser(
                                                                  uebung:
                                                                      uebung,
                                                                ))))
                                                  },
                                          style: TextButton.styleFrom(
                                            foregroundColor: uebungsErgebniss.isChecked
                                                ? Colors.grey
                                                : Colors.black, alignment: Alignment.centerLeft,
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              uebungenList
                                                  .remove(uebungsErgebniss);
                                            });
                                          },
                                          child: Text(
                                            uebung.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                          value: uebungsErgebniss.isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (uebungsErgebniss
                                                      .sets.length ==
                                                  0) {
                                                _showSnackBar(
                                                    "Vielleicht willst du erstmal ein paar Sets hinzufügen?");
                                              } else {
                                                uebungsErgebniss.isChecked =
                                                    !uebungsErgebniss.isChecked;
                                              }
                                            });
                                          }),
                                    )
                                  ],
                                ),
                                uebungsErgebniss.isChecked
                                    ? SizedBox.shrink()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: uebungsErgebniss.sets.length,
                                        itemBuilder: (context, indexSet) {
                                          Set set =
                                              uebungsErgebniss.sets[indexSet];
                                          return (indexSet !=
                                                      uebungsErgebniss
                                                              .sets.length -
                                                          1) &&
                                                  (uebungsErgebniss
                                                          .sets.length !=
                                                      0)
                                              ? Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 2.5, 0, 2.5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      //nicht das letzte set
                                                      Text("Set " +
                                                          (indexSet + 1)
                                                              .toString() +
                                                          ": "),
                                                      Text(set.repitions
                                                              .toString() +
                                                          "x "),
                                                      Text(set.wert.toString() +
                                                          "kg")
                                                    ],
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Divider(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        //das letzte Set, welches man bearbeiten möchte
                                                        Text("Set " +
                                                            (indexSet + 1)
                                                                .toString() +
                                                            ": "),
                                                        GestureDetector(
                                                            onTap: () {
                                                              _showSelectionDialog(
                                                                      set.repitions,
                                                                      50)
                                                                  .then((value) {
                                                                setState(() {
                                                                  if (value ==
                                                                      null) {
                                                                  } else {
                                                                    set.repitions =
                                                                        value;
                                                                  }
                                                                });
                                                              });
                                                            },
                                                            child: Text(
                                                              set.repitions
                                                                      .toString() +
                                                                  "x ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .purple,
                                                                  fontSize: 16),
                                                            )),
                                                        GestureDetector(
                                                            onTap: () {
                                                              _showSelectionDialog(
                                                                      set.wert,
                                                                      200)
                                                                  .then(
                                                                      (value) {
                                                                if (value !=
                                                                    null) {
                                                                  setState(() {
                                                                    set.wert =
                                                                        value;
                                                                  });
                                                                }
                                                              });
                                                            },
                                                            child: Text(
                                                                set.wert.toString() +
                                                                    "kg",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .purple,
                                                                    fontSize:
                                                                        16)))
                                                      ],
                                                    ),
                                                    Divider()
                                                  ],
                                                );
                                        }),
                                uebungsErgebniss.isChecked
                                    ? SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  uebungsErgebniss.sets
                                                      .add(Set(20, 10));
                                                });
                                              },
                                              icon: Icon(Icons.add)),
                                          uebungsErgebniss.sets.length == 0
                                              ? SizedBox.shrink()
                                              : IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      uebungsErgebniss.sets
                                                          .removeLast();
                                                    });
                                                  },
                                                  icon: Icon(Icons.delete)),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        );
                      })),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      _navigateAndDisplaySelection(context);
                    },
                    child: Icon(Icons.add)),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey,
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

  Future<int?> _showSelectionDialog(int startNumber, int endnumber) {
    int currentValue = startNumber;
    return showDialog<int>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              title: Center(child: const Text('Wähle')),
              content: StatefulBuilder(builder: (context, setState) {
                return NumberPicker(
                    minValue: 1,
                    maxValue: endnumber,
                    value: currentValue,
                    onChanged: (value) => setState(() {
                          currentValue = value;
                        }));
              }),
              actions: <Widget>[
                TextButton(
                  onPressed: () => {Navigator.pop(context, currentValue)},
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ));
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

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Uebung? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UebungSelector()),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;
    if (result == null) return;
    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    bool tmp = false;
    uebungenList.forEach((element) {
      if (element.uebung == result) {
        tmp = true;
      }
    });
    if (tmp == false) {
      setState(() {
        uebungenList.insert(0, UebungsErgebniss(result, [], false));
      });
    } else {
      _showSnackBar("Du hast die Übung bereits");
    }
  }

  void checkMaxFromUebungen() {
    uebungenList.forEach((element) {
      element.sets.forEach((elementSet) {
        if (elementSet.wert > element.uebung.maximum) {
          element.uebung.maximum = elementSet.wert;
        }
      });
    });
  }

  void tot(Training training) {
    bool tmp = uebungenList.every((element) => element.isChecked == true);
    if ((tmp == false) || (uebungenList.length == 0)) {
      _showSnackBar("Es sind noch nicht alle Übungen fertig!");
    } else {
      checkMaxFromUebungen();
      training.dauer = _stopwatch.elapsedMilliseconds;
      print(training.uebungErgebnisse.length);
      Provider.of<AppDataController>(context, listen: false)
          .addTraining(training);
      Provider.of<AppDataController>(context, listen: false).saveAppData();
      Navigator.pop(context);
    }
  }

  void _showSnackBar(String text) {
    var snackBar =
        SnackBar(duration: Duration(seconds: 1), content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

