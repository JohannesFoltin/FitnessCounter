import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class testScreen extends StatefulWidget {
  testScreen({Key? key}) : super(key: key);

  @override
  _testScreen createState() => _testScreen();
}

class _testScreen extends State<testScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
         margin: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Colors.red,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible( child: Text(" 4x")),
                  Expanded(
                    flex: 4,
                    child: TextButton(
                      onPressed: () => {print("tse"),_showFinishDialog()},
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                      ),
                      child: Text(
                        "Übung",
                        overflow: TextOverflow.ellipsis,
                      ),

                    ),
                  ),
                  Expanded(
                      child: TextField(
                        //controller: lastValueCont,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(),

                      )),
                  Flexible(
                      child: ElevatedButton(
                          onPressed: () => {},
                          child: Icon(Icons.check),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<String?> _showFinishDialog() {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          scrollable: true, // <-- Set it to true
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(onPressed: ()=>{Navigator.pop(context)}, child:Text("Fertig"))
          ],
          content: Column(
            children: [
              Divider(
                  color: Colors.black
              ),
              notizenContainer(),
              Divider(
                  color: Colors.black
              ),
              _buildBeschreibung(),
              Divider(
                  color: Colors.black
              ),
              _buildBild(),
              Divider(
                  color: Colors.black
              ),
            ],
          ),
        ));
  }

  Container _buildBild() {
    return Container(child: Column(
      children: [
        Text("bild"),
        Text("ToDo"),
      ],
    ));
  }

  Container _buildBeschreibung() {
    return Container(
      child: Column(
        children: [
          Text("Beschreibung"),
          Text(
            "asdasdasdasdasdasd",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Container notizenContainer(){
    return Container(
      child: Column(
        children: [
          Text("Notizen"),
          TextField(
            //controller: notizenCont,
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
                    // appData.uebungs
                    //     .firstWhere((element) => element.name == name)
                    //     .setNotizen(notizenCont.text),
                    // FocusScope.of(context).unfocus()
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
