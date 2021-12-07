import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class onFitness extends StatefulWidget {
  onFitness({
    Key? key,
    required this.test2,
  }) : super(key: key);

  String test2;

  @override
  _onFitness createState() => _onFitness();
}

abstract class ListItem {
  Widget buildCard(BuildContext context);
}

class CardItem implements ListItem {
  final String titel;
  final String beschreibung;
  final String bemerkungen;
  final String lastValue;

  CardItem(this.titel, this.beschreibung, this.bemerkungen, this.lastValue);

  @override
  Widget buildCard(BuildContext context) {
    return Visibility(
        child: Card(
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
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter a search term',
                ),
              ),
            ),
          ],
        ),
        trailing: CloseButton(
          onPressed: () => {}
        ),
        children: [TextButton(onPressed: () => {}, child: Text("Drück mal"))],
      ),
    ));
  }
}

class _onFitness extends State<onFitness> {
  _setStateLol() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            cardGenerator(),
            cardGenerator(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Training abbrechen"),
            )
          ],
        ),
      ),
    );
  }

  bool vis = true;

  Widget cardGenerator() {
    return Visibility(
        visible: vis,
        child: Card(
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Test",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                    hintText: 'Enter a search term',
                  ),
                  ),
                ),
              ],
            ),
            trailing: CloseButton(
              onPressed: () => setState(() {
                vis = false;
              }),
            ),
            children: [
            ExpansionTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("Erklärung"),
                children: [Text("datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata",textAlign: TextAlign.center,)],
            ),
               ExpansionTile(
                title: Text("Notizen"),
                controlAffinity: ListTileControlAffinity.leading,
                children: <Widget>[
                  TextField(
                    maxLines: null,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [TextButton(
                        onPressed:  () => {},
                        child: Text("Speichern"),
                      ),],
                    ),
                  ),
                ],
                )
              ],)
          ),
        );
  }
}
