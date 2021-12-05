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

class _onFitness extends State<onFitness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
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
    // TODO: implement build
  }

  final cardGenerator = () => Card(
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
            onPressed: () => {},
          ),
          children: [TextButton(onPressed: () => {}, child: Text("Drück mal"))],
        ),
      );
}
