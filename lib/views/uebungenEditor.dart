import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';

class UebungenEditor extends StatefulWidget {
  const UebungenEditor({Key? key, this.uebung}) : super(key: key);

  final Uebung? uebung;

  @override
  State<UebungenEditor> createState() => _UebungenEditorState();
}

class _UebungenEditorState extends State<UebungenEditor> {
  TextEditingController nameController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel_outlined),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Center(
                  child: Text("Name der Übung"),
                ),
                TextField(
                  controller: nameController,
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
