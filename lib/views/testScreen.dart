import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class testScreen extends StatefulWidget {
  testScreen({Key? key}) : super(key: key);
    bool cross = true;
  @override
  _testScreen createState() => _testScreen();
}

class _testScreen extends State<testScreen> {

  Widget widgetgeber() {
    if (widget.cross)
      return _NameWidgetAni();
    else
      return _ModulWidgetsAni();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Training"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
              height: 106,
              width: 375,
              color: Colors.red /* TODO BackgroundColor */,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: AnimatedSwitcher(
                        duration: const Duration(seconds: 2),
                        child: widgetgeber(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              child: TextFormField(
                                //ToDo Controller!
                                  keyboardType: TextInputType.number,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    hintText: "0", //ToDo last Value auslesen
                                  ),
                                  textAlign: TextAlign.center,
                              ),
                              width: 50,
                            ),
                            Text("kg")
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => {

                            }, //TODO Timer
                            child: Text("Start").textColor(Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _NameWidgetAni() {
    return Container(
      key: ValueKey<int>(1 //ToDO Index//
      ),
      height: 96,
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          setState(() {
            widget.cross = !widget.cross;
          });
        },
        child: Text("Test").textColor(Colors.black).fontSize(18),
      ),
    );
  }

  Widget _ModulWidgetsAni() {
    return Container(
      key: ValueKey<int>(0
      /*TODO index*/
      ),
      height: 96,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  widget.cross = !widget.cross;
                });
              },
              icon: Icon(Icons.keyboard_return)),
          Column(
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text("Bild").textColor(Colors.black)),
              TextButton(
                  onPressed: () {},
                  child: Text("Beschreibung").textColor(Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}
