import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class testScreen extends StatefulWidget {
  testScreen({Key? key}) : super(key: key);

  @override
  _testScreen createState() => _testScreen();
}

class _testScreen extends State<testScreen> {
  bool cross = true;
  Widget _widget1(){
    return TextButton(
      onPressed: () {
        setState(() {
          cross = !cross;
        });
      },
      child: Text("Test"),
    );
  }
  Widget _widget2(){
    return Container(
      height: 96,
      child: Column(
        children: [
          TextButton(
              onPressed: () {
                setState(() {
                  cross = !cross;
                });
              },
              child: Text("Bilder")),
          TextButton(onPressed: () {}, child: Text("Beschreibung")),
        ],
      ),
    );
  }
  Widget widgetgeber(){
    if(cross)return _widget1();
    else return _widget2();
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
      body: Container(
        color: Colors.purple,
          
        height: 98,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 150,
            child: AnimatedSwitcher(
                duration: const Duration(seconds: 2),
              child: widgetgeber(),
            ),
          ),
          Container(
            child: TextButton(
            onPressed: (){},
            child: Text("Hex"),
          ),)
        ],
      )),
    );
  }
}
