import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onFitness extends StatefulWidget {
  onFitness({
    Key? key,
    required this.items,
  }) : super(key: key);
  final List<ListItem> items;

  @override
  _onFitness createState() => _onFitness(items);
}

class _onFitness extends State<onFitness> {
  final List<ListItem> items;

  _onFitness(this.items);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children:[
          Expanded(child:
            ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return item.buildCard(context);
            }
            )
            ),
          TextButton(onPressed: ()=>{},child: Text("Training abbrechen"),),
        ],

      ),
    );
  }
}

abstract class ListItem {
  Widget buildCard(BuildContext context);
}

class CardItem implements ListItem {
  final String titel;
  final String beschreibung;
  final AssetImage pictureAsset;

  CardItem(this.titel, this.beschreibung,this.pictureAsset);

  TextEditingController lastValueCont = new TextEditingController();
  TextEditingController notizenCont = new TextEditingController();

  @override
  Widget buildCard(BuildContext context) {
    lastValueCont.selection = TextSelection.fromPosition(TextPosition(offset: lastValueCont.text.length));
    notizenCont.selection = TextSelection.fromPosition(TextPosition(offset: notizenCont.text.length));
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      lastValueCont.text = prefs.getString(titel + "_lastValue") ?? "0";
    });
    lastValueCont.addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(titel + "_lastValue", lastValueCont.text);
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      notizenCont.text = prefs.getString(titel + "_lastNotiz") ?? "Schreib was rein";
    });
    notizenCont.addListener(() async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(titel + "_lastNotiz", notizenCont.text);
    });
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
                controller: lastValueCont,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.check),
          onPressed: () => {
            //ToDO
          },
        ),
        children: [
          ExpansionTile(
            trailing: SizedBox.shrink(),
            title: new Center(
                child: Text("Erklärung")
            ),
            children: [
              Text(
                beschreibung,
                textAlign: TextAlign.center,
              )
            ],
          ),
          ExpansionTile(
            trailing: SizedBox.shrink(),
            title: new Center(
                child: Text("Bild")
            ),
            children: [
              Image(image: pictureAsset),
            ],
          ),

          ExpansionTile(
            trailing: SizedBox.shrink(),
            title: new Center(
                child: Text("Notizen")
            ),
            children: <Widget>[
              TextField(
                controller: notizenCont,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: new InputDecoration(
                  enabledBorder: const OutlineInputBorder(

                  ),),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => {
                      FocusScope.of(context).unfocus()
                      },
                      child: Text("Speichern"),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
