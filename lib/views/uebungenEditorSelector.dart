import 'package:fitness_f/views/uebungenEditor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/controller.dart';
import '../models/uebung.dart';

class UebungenEditorSelector extends StatefulWidget {
  const UebungenEditorSelector({Key? key}) : super(key: key);

  @override
  State<UebungenEditorSelector> createState() => _UebungenEditorSelectorState();
}

class _UebungenEditorSelectorState extends State<UebungenEditorSelector> {
  @override
  Widget build(BuildContext context) {
    List<Uebung> uebungen =
        Provider.of<AppDataController>(context).appData.uebungs;
    return Scaffold(
      appBar: AppBar(
        title: Text("Wähle eine Übung zum ändern"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: uebungen.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => editUebung(uebungen[index]),
                    child: Card(
                      child: Container(
                          width: double.infinity,
                          height: 50,
                          child: Center(child: Text(uebungen[index].name))),
                    ),
                  );
                }),
          ),
          ElevatedButton(
              onPressed: () => editUebung(null),
              child: Text("Neue Übung hinzufügen"))
        ],
      ),
    );
  }

  void editUebung(Uebung? uebung) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UebungenEditor(
                  uebung: uebung,
                )));
  }
}
