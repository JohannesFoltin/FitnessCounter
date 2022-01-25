import 'dart:async';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class onFitness extends StatefulWidget {
  onFitness({Key? key, required this.appData}) : super(key: key);

  final AppData appData;

  @override
  _onFitness createState() => _onFitness();

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

class _onFitness extends State<onFitness> {
  bool run = true;
  Stopwatch _stopwatch = new Stopwatch();
  late List<CardItem> uebungenLeft;
  late Training training;
  Color ButtonColor = Colors.orange;

  @override
  void initState() {
    // TODO: implement initState
    _stopwatch.start();
    uebungenLeft = widget.appData
        .getUebungs()
        .map((u) => new CardItem(widget.appData, u.name))
        .toList();
    training = new Training(BigInt.zero, BigInt.zero, []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                        height: 150,
                        width: 150,
                        color: ButtonColor,
                        child: _buildTimeController(context)),
                  )
                ],
              ),
            ),
            Expanded(child: _buildUebungenList()),
          ],
        ),
      ),
    );
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
    );
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
    widget.appData.trainings.add(training);
    Navigator.pop(context);
  }

  void removeItem(CardItem c) {
    setState(() {
      uebungenLeft.remove(c);
    });
    UebungsErgebnisse uebungsErgebniss =
        new UebungsErgebnisse(c.name, c.lastValueCont.text, BigInt.zero);
    training.uebungErgebnisse.add(uebungsErgebniss);
    if (uebungenLeft.isEmpty) {
      tot(training);
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

class CardItem implements ListItem {
  late final AppData appData;
  late final String name;
  late Uebung uebung;
  Stopwatch _stopwatch = new Stopwatch();

  void _handleTimer() {
    if (_stopwatch.isRunning)
      _stopwatch.stop();
    else
      _stopwatch.start();
  }

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
      lastValueCont.text = appData.trainings.last.uebungErgebnisse
          .firstWhere((element) => element.name == name)
          .wert;
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

class TimerField extends StatefulWidget {
  TimerField(this.stopwatchi, this.returnHours);

  final Stopwatch stopwatchi;
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
        onFitness.formatTime(widget.stopwatchi.elapsedMilliseconds, true),
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
      );
    } else {
      return Text(
        onFitness.formatTime(widget.stopwatchi.elapsedMilliseconds, false),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      );
    }
  }
}
