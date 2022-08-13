import 'package:fitness_f/controller/controller.dart';
import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UebungSelector extends StatefulWidget {
  const UebungSelector({Key? key}) : super(key: key);

  @override
  State<UebungSelector> createState() => _UebungSelectorState();
}
//Typen: Brust,Schultern,Arme,Bauch,Beine,Rücken

class _UebungSelectorState extends State<UebungSelector> {
  @override
  Widget build(BuildContext context) {
    List<Uebung> uebungen =
        Provider.of<AppDataController>(context).appData.uebungs;
    return Scaffold(
      appBar: AppBar(
        title: Text("Wähle deine Übung"),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: uebungen.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, uebungen[index]);
              },
              child: Card(
                child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(child: Text(uebungen[index].name))),
              ),
            );
          }),
    );
  }
}
