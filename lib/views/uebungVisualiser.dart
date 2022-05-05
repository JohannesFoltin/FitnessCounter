import 'package:fitness_f/models/datalayer.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    notizenCont.selection = TextSelection.fromPosition(
        TextPosition(offset: notizenCont.text.length));
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () => {Navigator.pop(context)},
                icon: Icon(Icons.arrow_back)),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Divider(color: Colors.black),
            notizenContainer(context),
            Divider(color: Colors.black),
            _buildBild(),
            Divider(color: Colors.black),
            _buildBeschreibung(),
            Divider(color: Colors.black),
          ],
        ));
  }

  Container _buildBild() {
    return Container(
        child: Column(
      children: [
        Text("Bild"),
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
          Text("Notizen"),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => {
                    //noteBuffer = notizenCont.text,
                    widget.uebung.notizen = notizenCont.text,
                    FocusScope.of(context).unfocus()
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
