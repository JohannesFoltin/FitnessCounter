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

  final TrainingPlan trainingPlan;

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
  late List<UebungItem> uebungenLeft;
  late Training training;
  Color buttonColor = Colors.orange;
  late TimerController _countDownController;
  late final DateTime dateCode;

  @override
  void initState() {
    _countDownController = TimerController(this);
    _stopwatch.start();
    dateCode = DateTime.now();
    training = new Training(0, dateCode, widget.trainingPlan.name,[]);
    uebungenLeft =
        widget.trainingPlan.exercises.map((u) => new UebungItem(u)).toList();
    print("I listed");
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text("Zeit in der Übung"),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                              height: 150,
                              width: 150,
                              color: buttonColor,
                              child: _buildTimeController(context)),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Pause Timer"),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: _buildCountdown(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(child: _buildUebungenList()),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCountdown() {
    return Container(
        height: 100,
        width: 100,
        color: Colors.red,
        child: TextButton(
          onPressed: () => {
            if (_countDownController.isAnimating)
              {_countDownController.stop()}
            else
              {_countDownController.start()}
          },
          onLongPress: () => {_countDownController.reset()},
          child: SimpleTimer(
            controller: _countDownController,
            progressTextStyle: TextStyle(fontSize: 18, color: Colors.black),
            displayProgressIndicator: false,
            duration: Duration(minutes: 1, seconds: 30),
            progressTextCountDirection:
                TimerProgressTextCountDirection.count_down,
            onEnd: () => {_countDownController.reset()},
          ),
        ));
  }

  TextButton _buildTimeController(BuildContext context) {
    return TextButton(
      onPressed: () => {
        setState(() {
          handleStartStop();
          if (buttonColor == Colors.orange) {
            buttonColor = HexColor.fromHex("#008060");
          } else {
            buttonColor = Colors.orange;
          }
        })
      },
      onLongPress: () => {
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  title:
                      const Text('Willst du das Training wirklich abbrechen?'),
                  content: const Text('Alles geht verloren...'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () =>
                          {Navigator.pop(context), Navigator.pop(context)},
                      child: const Text('OK'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                  ],
                )),
      },
      child: TimerField(_stopwatch, true),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HexColor.fromHex("#006666"),
      automaticallyImplyLeading: false,
      title: Text("Training am " +
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

  ListView _buildUebungenList() {
    return ListView.builder(
        itemCount: uebungenLeft.length,
        itemBuilder: (context, index) {
          final item = uebungenLeft[index];
          return item.buildCard(context, removeItem);
        });
  }

  void tot(Training training) {
    training.dauer = _stopwatch.elapsedMilliseconds;
    Provider.of<AppDataController>(context, listen: false)
        .addTraining(training);
    Provider.of<AppDataController>(context, listen: false).saveAppData();
    Navigator.pop(context);
  }

  void removeItem(UebungItem c) {
    setState(() {
      uebungenLeft.remove(c);
      UebungsErgebniss uebungsErgebniss =
          new UebungsErgebniss(c.uebung.name, c.reps, 0);
      training.uebungErgebnisse.add(uebungsErgebniss);
    });
    if (uebungenLeft.isEmpty) {
      _showFinishDialog();
    }
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

abstract class ListItem {
  Widget buildCard(BuildContext context, Function r);
}

class UebungItem implements ListItem {
  Uebung uebung;
  late int remainingreps;
  List<Rep> reps = [];

  TextEditingController lastValueCont = new TextEditingController();
  TextEditingController notizenCont = new TextEditingController();

  UebungItem(this.uebung) {
    remainingreps = uebung.reps;
    notizenCont.text = uebung.notizen;
  }

  @override
  Widget buildCard(BuildContext context, Function r) {
    lastValueCont.selection = TextSelection.fromPosition(
        TextPosition(offset: lastValueCont.text.length));
    notizenCont.selection = TextSelection.fromPosition(
        TextPosition(offset: notizenCont.text.length));
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return Container(
        margin: const EdgeInsets.fromLTRB(10.0, 2.5, 10.0, 2.5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            color: HexColor.fromHex(uebung.color),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: Text(" x" + remainingreps.toString()),
                ),
                Expanded(
                  flex: 4,
                  child: TextButton(
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => UebungVisualiser(
                                    uebung: uebung,
                                  ))))
                    },
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      primary: Colors.black,
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      uebung.name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Expanded(
                    child: SizedBox(
                  height: 25,
                  child: TextField(
                    controller: lastValueCont,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                )),
                Flexible(
                    child: ElevatedButton(
                  onPressed: () => {
                    if (lastValueCont.text == "")
                      {print("Error. No lastValueCont text")},
                    setState(() {
                      remainingreps--;
                    }),
                    reps.add(new Rep(int.parse(lastValueCont.text))),
                    lastValueCont.clear(),
                    if (remainingreps == 0) {r(this)}
                  },
                  onLongPress: () => {
                    if (lastValueCont.text == "")
                      {print("Error. No lastValueCont text")}
                    else
                      {
                        for (int i = 0; i < remainingreps; i++)
                          {
                            reps.add(new Rep(int.parse(lastValueCont.text))),
                          },
                        remainingreps = 0,
                        r(this),
                      }
                  },
                  child: Icon(Icons.check),
                )),
              ],
            ),
          ),
        ),
      );
    });
  }

  Container notizenContainer(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Notizen"),
          TextField(
            controller: notizenCont,
            minLines: 5,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: new InputDecoration(
              enabledBorder: const OutlineInputBorder(),
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {
                    //noteBuffer = notizenCont.text,
                    uebung.notizen = notizenCont.text,
                    FocusScope.of(context).unfocus()
                  },
                  child: Text("Speichern"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
