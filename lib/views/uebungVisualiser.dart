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
  List<UebungsErgebniss> lastTrainingsUebungsResults = [];
  @override
  void initState() {
    notizenCont.text = widget.uebung.notizen;
    lastTrainingsUebungsResults = getUebungsErgebnisse(context);
    super.initState();
  }

  List<UebungsErgebniss> getUebungsErgebnisse(BuildContext context) {
    List<UebungsErgebniss> tmp = [];
    Provider.of<AppDataController>(context, listen: false)
        .appData
        .trainings
        .forEach((element) {
      element.uebungErgebnisse.forEach((e) {
        if (e.uebung.name == widget.uebung.name) {
          tmp.add(e);
        }
      });
    });
    print(tmp.length.toString());
    return tmp;
  }

  String getMax() {
    int max = 0;
    if (lastTrainingsUebungsResults.isEmpty) {
      return "Bis jetzt noch nicht absolviert. ERROR";
    }
    lastTrainingsUebungsResults.forEach((element) {
      element.sets.forEach((e) {
        if (e.wert > max) {
          max = e.wert;
        }
      });
    });
    return max.toString();
  }

  String getMin() {
    int min = 99999999;
    if (lastTrainingsUebungsResults.isEmpty) {
      return "Bis jetzt noch nicht absolviert. ERROR";
    }
    lastTrainingsUebungsResults.forEach((element) {
      element.sets.forEach((e) {
        if (e.wert < min && e.wert != 0) {
          min = e.wert;
        }
      });
    });
    return min.toString();
  }

  String lastTraing() {
    if (lastTrainingsUebungsResults.isEmpty) {
      return "Bis jetzt noch nicht absolviert. ERROR";
    }
    String tmp = "";
    UebungsErgebniss uTmp = lastTrainingsUebungsResults.last;
    for (var i = 0; i < uTmp.sets.length; i++) {
      tmp = tmp + uTmp.sets[i].wert.toString() + "kg, ";
    }
    return tmp;
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
                          Text(" Max: " + getMax() + "kg"),
                          Text(" Min: " + getMin() + "kg"),
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
