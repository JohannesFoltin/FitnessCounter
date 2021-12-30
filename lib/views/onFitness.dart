import 'dart:async';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onFitness extends StatefulWidget {
  onFitness({
    Key? key,
    required this.appData
  }) : super(key: key);

  final AppData appData;


  @override
  _onFitness createState() => _onFitness();

  static String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}

class _onFitness extends State<onFitness> {
  bool run = true;
  Stopwatch _stopwatch = new Stopwatch();
  late List<CardItem> uebungenLeft;
  late Training training;
  @override
  void initState() {
    // TODO: implement initState
    _stopwatch.start();
    uebungenLeft =  widget.appData.getUebungs().map((u) => new CardItem(widget.appData, u.name)).toList();
    training = new Training(BigInt.zero, BigInt.zero, []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildUebungenList(),
          Container(
            child: Row(
              children: [
                if (run == false) ...[
                  _buildStartButton()
                ] else ...[
                  _buildPauseButton()
                ],
                _buildStopButton(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: HexColor.fromHex("#006666"),
      automaticallyImplyLeading: false,
      title: Text("Training"),
      actions: <Widget>[Center(child: TimerField(_stopwatch))],
    );
  }

  Expanded _buildUebungenList() {
    return Expanded(
        child: ListView.builder(
            itemCount: uebungenLeft.length,
            itemBuilder: (context, index) {
              final item = uebungenLeft[index];
              return item.buildCard(context, removeItem);
            }));
  }

  Expanded _buildPauseButton() {
    return Expanded(
        flex: 3,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          child: Icon(
            Icons.pause,
            color: Colors.white,
          ),
          onPressed: () => {
            setState(() {
              run = !run;
              handleStartStop();
            })
          },
        ));
  }

  Expanded _buildStopButton(BuildContext context) {
    return Expanded(
        child: TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor.fromHex("#990000")),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
      child: Icon(
        Icons.stop,
        color: Colors.white,
      ),
      onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                actionsAlignment: MainAxisAlignment.center,
                title: const Text('Willst du das Training wirklich abbrechen?'),
                content: const Text(
                    'Bereits eingetragende Werte gehen nicht verloren!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {Navigator.pop(context) /*TODO*/ },
                    child: const Text('OK'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                ],
              )),
    ));
  }

  Expanded _buildStartButton() {
    return Expanded(
        child: TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(HexColor.fromHex("#008060")),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
      ),
      onPressed: () => {
        setState(() {
          run = !run;
          handleStartStop();
        })
      },
    ));
  }

  void tot(Training training) {
    widget.appData.trainings.add(training);
    Navigator.pop(context);
  }

  //TODO FIX ME!!!
  void removeItem(CardItem c) {
    uebungenLeft.remove(c);
    UebungsErgebnisse uebungsErgebniss = new UebungsErgebnisse(c.name,c.lastValueCont.text,0 as BigInt);
    training.uebungErgebnisse.add(uebungsErgebniss);
    if(uebungenLeft.isEmpty){
      tot(training);
    }
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
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

  CardItem(AppData appData, String name){
   this.uebung = appData.getUebungByName(name);
   this.appData = appData;
   this.name = name;
  }

  TextEditingController lastValueCont = new TextEditingController();
  TextEditingController notizenCont = new TextEditingController();

  @override
  Widget buildCard(BuildContext context, Function r) {
    lastValueCont.selection = TextSelection.fromPosition(
        TextPosition(offset: lastValueCont.text.length));

    notizenCont.selection = TextSelection.fromPosition(
        TextPosition(offset: notizenCont.text.length));

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      lastValueCont.text = prefs.getString(uebung.name + "_lastValue") ?? "0";
    });

    lastValueCont.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(uebung.name + "_lastValue", lastValueCont.text);
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      notizenCont.text =
          prefs.getString(uebung.name + "_lastNotiz") ?? "Schreib was rein";
    });

    notizenCont.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(uebung.name + "_lastNotiz", notizenCont.text);
    });

    return Visibility(
      child: Card(
          color: HexColor.fromHex(uebung.color),
          child: ExpansionTile(
            title: Text(
              uebung.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: lastValueCont,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(),
                  ),
                ),
                _buildCheckButton(r),
              ],
            ),
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
      child: Icon(
        Icons.check,
      ),
      onPressed: () => {r(this)},
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(), padding: EdgeInsets.all(10)),
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
                onPressed: () => {FocusScope.of(context).unfocus()},
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
  TimerField(this.stopwatchi);

  final Stopwatch stopwatchi;

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
    return Text(
      onFitness.formatTime(widget.stopwatchi.elapsedMilliseconds),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
