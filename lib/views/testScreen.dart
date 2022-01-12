import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class testScreen extends StatefulWidget {
  testScreen({Key? key}) : super(key: key);

  @override
  _testScreen createState() => _testScreen();
}

class _testScreen extends State<testScreen> {
  bool cross = true;

  Widget _widget1() {
    return Container(
      key: ValueKey<int>(1),
      height: 96,
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          setState(() {
            cross = !cross;
          });
        },
        child: Text("Test").textColor(Colors.black).fontSize(18),
      ),
    );
  }

  Widget _widget2() {
    return Container(
      key: ValueKey<int>(0),
      height: 96,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(onPressed: (){ setState(() {
            cross = !cross;
          });}, icon: Icon(Icons.keyboard_return)),
          Column(
            children: [
              TextButton(
                  onPressed: () {

                  },
                  child: Text("Bild").textColor(Colors.black)),
              TextButton(

                  onPressed: () {}, child:
              Text("Beschreibung").textColor(Colors.black)
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget widgetgeber() {
    if (cross)
      return _widget1();
    else
      return _widget2();
  }

  CrossFadeState _crossfadeState() {
    if (cross)
      return CrossFadeState.showFirst;
    else
      return CrossFadeState.showSecond;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Training"),
      ),
      body: Column(
        children: [
          Container(
            height: 100,
          ),
          buildSlidable("s"),
          buildSlidable("s"),

        ],
      ),
    );
  }

  SlidableAutoCloseBehavior buildSlidable(String key) {
    return SlidableAutoCloseBehavior(
      child: Slidable(
            groupTag: key,
            startActionPane: ActionPane(
              extentRatio: 0.40,
              motion: const ScrollMotion(),
              children: [
                Container(
                    child: Text("data"),
                  color: Colors.lightGreen,
                )
              ],

            ),
          //  child: ClipRRect(
            //  borderRadius: BorderRadius.circular(150.0),
              child:
              Container(
                  height: 106,
                  width: 300,
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        child: AnimatedSwitcher(
                          duration: const Duration(seconds: 2),
                          child: widgetgeber(),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 50,
                            child: TextField(

                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(),
                            ),
                          ),
                          Container(
                            child: TextButton(
                              onPressed: () => {
                                print("test")
                              },
                              child: Text("Hex").textColor(Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            //),
          ),
    );
  }

}
