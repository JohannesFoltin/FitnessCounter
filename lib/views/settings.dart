import 'package:fitness_f/views/uebungenEditorSelector.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UebungenEditorSelector()));
            },
            child: Container(
              child: Column(
                children: [
                  Divider(),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.rule_rounded),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Ändere Übungen")
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          Center(child: const Text("Version 1.0"))
        ],
      ),
    );
  }
}
