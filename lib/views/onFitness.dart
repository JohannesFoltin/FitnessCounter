import 'dart:async';
import 'dart:ui';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/main.dart';
import 'package:fitness_f/views/trainingResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_timer/simple_timer.dart';

class OnFitness extends StatefulWidget {
  OnFitness({Key? key, required this.appData}) : super(key: key);

  final AppData appData;

  @override
  _OnFitness createState() => _OnFitness();

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
  Color ButtonColor = Colors.orange;
  late TimerController _timerController;
  late final DateTime DateCode;

  @override
  void initState() {
    // TODO: implement initState
    _timerController = TimerController(this);
    _stopwatch.start();
    DateCode = DateTime.now();
    uebungenLeft = widget.appData
        .getUebungs()
        .map((u) => new UebungItem(widget.appData, u.name))
        .toList();
    training = new Training(0, DateCode, []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async => false,
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
                              color: ButtonColor,
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
            if (_timerController.isAnimating)
              {_timerController.stop()}
            else
              {_timerController.start()}
          },
          onLongPress: () => {_timerController.reset()},
          child: SimpleTimer(
            controller: _timerController,
            progressTextStyle: TextStyle(fontSize: 18, color: Colors.black),
            displayProgressIndicator: false,
            duration: Duration(minutes: 1, seconds: 30),
            progressTextCountDirection:
                TimerProgressTextCountDirection.count_down,
            onEnd: () => {_timerController.reset()},
          ),
        ));
  }

  TextButton _buildTimeController(BuildContext context) {
    return TextButton(
      onPressed: () => {
        setState(() {
          handleStartStop();
          if (ButtonColor == Colors.orange) {
            ButtonColor = HexColor.fromHex("#008060");
          } else {
            ButtonColor = Colors.orange;
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
                  content: const Text(
                      'Bereits eingetragende Werte gehen nicht verloren! Notizen bleiben aber erhalten...'),
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
      centerTitle: true,
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
    widget.appData.trainings.add(training);
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) =>
    //             TrainingResult(appData: widget.appData, training: training,)));
    //Navigator.pop(context);
    Navigator.pop(context);
  }

  void removeItem(UebungItem c) {
    //ACHTUNG SEHR HÄSSLICH
    //TODOint
    if (c.remainingwiederholung == 0) {
      uebungenLeft.remove(c);
      UebungsErgebniss uebungsErgebniss = new UebungsErgebniss(c.name, c.reps, 0);
      training.uebungErgebnisse.add(uebungsErgebniss);
    }
    setState(() {});
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
  late final AppData appData;
  late final String name;
  late Uebung uebung;
  late int remainingwiederholung;
  late List<wiederholung> reps;

  TextEditingController lastValueCont = new TextEditingController();
  TextEditingController notizenCont = new TextEditingController();

  UebungItem(
    AppData appData,
    String name,
  ) {
    this.uebung = appData.getUebungByName(name);
    this.appData = appData;
    this.name = name;
    initValues();
  }

  initValues() {
    reps = [];
    remainingwiederholung =
        appData.uebungs.firstWhere((element) => element.name == name).reps;
    notizenCont.text =
        appData.uebungs.firstWhere((element) => element.name == name).notizen;
  }

  @override
  Widget buildCard(BuildContext context, Function r) {
    lastValueCont.selection = TextSelection.fromPosition(
        TextPosition(offset: lastValueCont.text.length));

    notizenCont.selection = TextSelection.fromPosition(
        TextPosition(offset: notizenCont.text.length));
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
                child: Text(" x" + remainingwiederholung.toString()),
              ),
              Expanded(
                flex: 4,
                child: TextButton(
                  onPressed: () => {print("tse"), _showInfoScreen(context)},
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
                  if(lastValueCont.text == ""){
                    print("Error. No lastValueCont text")
                  }
                  else if (remainingwiederholung > 0)
                    {
                      remainingwiederholung--,
                      reps.add(new wiederholung(int.parse(lastValueCont.text))),
                      lastValueCont.clear(),
                      r(this)
                    }
                  else
                    {r(this)},
                },
                onLongPress: () => {
                  if(lastValueCont.text == ""){
                    print("Error. No lastValueCont text")
                  }
                  else
                    {
                      for (int i = 0; i < remainingwiederholung; i++)
                        {
                          reps.add(new wiederholung(int.parse(lastValueCont.text))),
                        },
                      remainingwiederholung = 0,
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
  }

  Future<String?> _showInfoScreen(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              scrollable: true, // <-- Set it to true
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text("Fertig"))
              ],
              content: Column(
                children: [
                  Divider(color: Colors.black),
                  _buildBild(),
                  Divider(color: Colors.black),
                  _buildBeschreibung(),
                  Divider(color: Colors.black),
                  notizenContainer(context),
                  Divider(color: Colors.black),
                ],
              ),
            ));
  }

  Container _buildBild() {
    return Container(
        child: Column(
      children: [
        Text("Bild"),
        Image(image: AssetImage(uebung.pictureAsset)),
      ],
    ));
  }

  Container _buildBeschreibung() {
    return Container(
      child: Column(
        children: [
          Text("Beschreibung"),
          Text(
            uebung.beschreibung,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
                    appData.uebungs
                        .firstWhere((element) => element.name == name)
                        .setNotizen(notizenCont.text),
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
/*
class CardItem implements ListItem {
  late final AppData appData;
  late final String name;
  late Uebung uebung;

  TextEditingController lastValueCont = new TextEditingController();
  TextEditingController notizenCont = new TextEditingController();

  CardItem(AppData appData, String name) {
    this.uebung = appData.getUebungByName(name);
    this.appData = appData;
    this.name = name;
    initValues();
  }

  initValues() {
    if (appData.trainings.isNotEmpty) {
     //ToDO
    }
    notizenCont.text =
        appData.uebungs.firstWhere((element) => element.name == name).notizen;
  }

  @override
  Widget buildCard(BuildContext context, Function r) {
    lastValueCont.selection = TextSelection.fromPosition(
        TextPosition(offset: lastValueCont.text.length));

    notizenCont.selection = TextSelection.fromPosition(
        TextPosition(offset: notizenCont.text.length));

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Card(
          key: Key(name),
          color: HexColor.fromHex(uebung.color),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  uebung.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: lastValueCont,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(),
                  ),
                ),
              ],
            ),
            trailing: _buildCheckButton(r),
            children: [
              _buildNotizen(context),
              _buildBeschreibung(),
              _buildBild(),
            ],
          )),
    );
  }

  ElevatedButton _buildCheckButton(Function r) {
    return ElevatedButton(
      child: Icon(Icons.check),
      onPressed: () => {r(this)},
    );
  }

  ExpansionTile _buildBild() {
    return ExpansionTile(
      trailing: SizedBox.shrink(),
      title: new Center(child: Text("Bild")),
      children: [
        Image(image: AssetImage(uebung.pictureAsset)),
      ],
    );
  }

  ExpansionTile _buildBeschreibung() {
    return ExpansionTile(
      trailing: SizedBox.shrink(),
      title: new Center(child: Text("Erklärung")),
      children: [
        Text(
          uebung.beschreibung,
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  ExpansionTile _buildNotizen(BuildContext context) {
    return ExpansionTile(
      trailing: SizedBox.shrink(),
      title: new Center(child: Text("Notizen")),
      children: <Widget>[
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
                  appData.uebungs
                      .firstWhere((element) => element.name == name)
                      .setNotizen(notizenCont.text),
                  FocusScope.of(context).unfocus()
                },
                child: Text("Speichern"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
*/

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
