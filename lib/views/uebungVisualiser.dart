import 'package:fitness_f/controller/controller.dart';
import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UebungVisualiser extends StatefulWidget {
  const UebungVisualiser({Key? key, required this.uebung}) : super(key: key);

  final Uebung uebung;

  @override
  State<UebungVisualiser> createState() => _UebungVisualiserState();
}

class _UebungVisualiserState extends State<UebungVisualiser> {
  TextEditingController notizenCont = new TextEditingController();
  @override
  void initState() {
    notizenCont.text = widget.uebung.notizen;
    super.initState();
  }

  String lastTraing() {
    var appData =
        Provider.of<AppDataController>(context, listen: false).appData;
    if (!appData.trainings.any((element) => element.uebungErgebnisse
        .any((element) => element.uebung == widget.uebung))) {
      return "Noch nicht absolviert";
    } else {
      String tmp = "";
      Training uTraining = appData.trainings.lastWhere((element) => element
          .uebungErgebnisse
          .any((element) => element.uebung == widget.uebung));
      UebungsErgebniss uTmp = uTraining.uebungErgebnisse
          .firstWhere((element) => element.uebung == widget.uebung);
      for (var i = 0; i < uTmp.sets.length; i++) {
        tmp = tmp + uTmp.sets[i].wert.toString() + "kg, ";
      }
      return tmp;
    }
  }

  @override
  Widget build(BuildContext context) {
    notizenCont.selection = TextSelection.fromPosition(
        TextPosition(offset: notizenCont.text.length));
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.uebung.name),
        ),
        body: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBild(),
                Divider(
                  color: Colors.black,
                ),
                ExpansionTile(
                  children: [notizenContainer(context)],
                  title: Text("Notizen"),
                ),
                ExpansionTile(
                  children: [_buildBeschreibung()],
                  title: Text("Beschreibung"),
                ),
                Divider(
                  color: Colors.black,
                ),
                Card(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(" Max: " +
                              widget.uebung.maximum.toString() +
                              "kg"),
                          Text(" Beim letzten Training: " + lastTraing()),
                          SizedBox(
                            height: 5,
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Container _buildBild() {
    return Container(
        child: Column(
      children: [
        Image(image: AssetImage(widget.uebung.pictureAsset)),
      ],
    ));
  }

  Container _buildBeschreibung() {
    return Container(
      child: Column(
        children: [
          Text("Beschreibung"),
          Text(
            widget.uebung.beschreibung,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Container notizenContainer(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: notizenCont,
            minLines: 5,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: new InputDecoration(
              enabledBorder: const OutlineInputBorder(),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => {
                //noteBuffer = notizenCont.text,
                widget.uebung.notizen = notizenCont.text,
                FocusScope.of(context).unfocus()
              },
              child: Text("Speichern"),
            ),
          ),
        ],
      ),
    );
  }
}
