import 'dart:async';

import 'package:fitness_f/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onFitness extends StatefulWidget {
  onFitness({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<ListItem> items;

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
  bool run = false;
  Stopwatch _stopwatch = new Stopwatch();

  void tot() {
    Navigator.pop(context);
  }
  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
  }
  void removeItem(CardItem c) {
    if (widget.items.length == 1) tot();
    setState(() {
      widget.items.remove(c);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor.fromHex("#006666"),
        automaticallyImplyLeading: false,
        title: Text("Training"),
        actions: <Widget>[Center(child: TimerField(_stopwatch))],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return item.buildCard(context, removeItem);
                  })),
          Container(
            child: Row(
              children: [
                if (run == false) ...[
                  Expanded(
                      child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HexColor.fromHex("#008060")),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                  ))
                ] else ...[
                  Expanded(
                      flex: 3,
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.orange),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                      ))
                ],
                Expanded(
                    child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          HexColor.fromHex("#990000")),
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
                            title: const Text(
                                'Willst du das Training wirklich abbrechen?'),
                            content: const Text(
                                'Bereits eingetragende Werte gehen nicht verloren!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    {Navigator.pop(context), tot()},
                                child: const Text('OK'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                            ],
                          )),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

abstract class ListItem {
  Widget buildCard(BuildContext context, Function r);
}

class CardItem implements ListItem {
  final String titel;
  final String beschreibung;
  final AssetImage pictureAsset;
  final Color bcolor;

  CardItem(this.titel, this.beschreibung, this.pictureAsset, this.bcolor);

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
      lastValueCont.text = prefs.getString(titel + "_lastValue") ?? "0";
    });

    lastValueCont.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(titel + "_lastValue", lastValueCont.text);
    });

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      notizenCont.text =
          prefs.getString(titel + "_lastNotiz") ?? "Schreib was rein";
    });

    notizenCont.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(titel + "_lastNotiz", notizenCont.text);
    });

    return Visibility(
      child: Card(
          color: bcolor,
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titel,
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
            trailing: ElevatedButton(
              child: Icon(
                Icons.check,
              ),
              onPressed: () => {r(this)},
              style: ElevatedButton.styleFrom(
                  shape: CircleBorder(), padding: EdgeInsets.all(10)),
            ),
            children: [
              ExpansionTile(
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
              ),
              ExpansionTile(
                trailing: SizedBox.shrink(),
                title: new Center(child: Text("Erklärung")),
                children: [
                  Text(
                    beschreibung,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              ExpansionTile(
                trailing: SizedBox.shrink(),
                title: new Center(child: Text("Bild")),
                children: [
                  Image(image: pictureAsset),
                ],
              ),
            ],
          )),
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
