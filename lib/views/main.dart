import 'dart:convert';

import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/appData_provider.dart';
import 'package:fitness_f/views/onFitness.dart';
import 'package:fitness_f/views/testScreen.dart';
import 'package:fitness_f/views/trainingResult.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppDataProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          'home': (context) => MyHomePage(),
        },
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoaded = false;

  //Wichitg! Future<void> ist wichtig für .then()

  Future<void> loadAppData() async {
    final prefs = await SharedPreferences.getInstance();
    AppDataProvider.of(context).appData = AppData.fromJson(jsonDecode(
        prefs.getString("1, 2, 3, 5, 8, 13, 21, 34") ??
            "{\"trainingsPlans\":" +
                jsonEncode(initTrainingPlans()) +
                ", \"trainings\":[]}"));
    print("loaded");
  }

  Future<void> saveAppData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("1, 2, 3, 5, 8, 13, 21, 34",
        jsonEncode(AppDataProvider.of(context).appData));
    print("AppData Saved");
    setState(() {});
  }

  @override
  void initState() {
    loadAppData().then((value) => {isLoaded = true, setState(() {})});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget? myWidget;
    if (isLoaded == false) {
      myWidget = CircularProgressIndicator();
    } else {
      myWidget = buildEverything(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness 3000", style: GoogleFonts.notoSans())
            .textColor(Colors.black)
            .fontSize(25),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: myWidget,
    );
  }

  Center buildEverything(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 4,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            "Absolvierte Trainings diesen Monat: " +
                AppDataProvider.of(context)
                    .getTrainingsThisMonth(DateTime.now())
                    .toString(),
          ).fontSize(18).center(),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OnFitness(
                                    trainingPlan: AppDataProvider.of(context)
                                        .appData
                                        .trainingsPlans
                                        .first,
                                  ))).then((_) {
                        saveAppData();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TrainingResult(
                                    training: AppDataProvider.of(context)
                                        .appData
                                        .trainings
                                        .last)));
                      });
                    },
                    child: Text("Start Training"),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.black26),
                      onPressed: () {
                        if (AppDataProvider.of(context)
                            .appData
                            .trainings
                            .isEmpty) {
                          print("No Trainings available");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrainingResult(
                                      training: AppDataProvider.of(context)
                                          .appData
                                          .trainings
                                          .last)));
                        }
                      },
                      child: Text("Last Training")),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 100,
          margin: const EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ElevatedButton(
              onPressed: () {
                loadAppData();
                setState(() {});
              },
              child: Text("Trainings"),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestScreen()));
            },
            child: Text("Go to Test Screen")),
        TextButton(
          onPressed: () {
            ichhassemeinLeben();
          },
          child: Text("Hard reset"),
        ),
        Text(AppDataProvider.of(context)
            .appData
            .trainingsPlans
            .length
            .toString())
      ],
    ));
  }

  ichhassemeinLeben() async {
    AppDataProvider.of(context).appData = new AppData([], []);
    var prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) => {loadAppData(), setState(() {})});
    print("everything is restet");
  }

  List<TrainingPlan> initTrainingPlans() {
    String flachbankdrueckenMaschineBeschreibung =
        "Wir greifen den horizontalen Griff so weit außen wie möglich, damit wir so stark wie nur möglich die Brust trainieren. Je enger wir greifen, desto verstärkt belasten wir den Trizeps, wie bei der Übung enges Bankdrücken. Stelle den Sitz für das Training so ein, dass die Griffe auf der Höhe deiner Brust sind. Aus der Kraft der Brustmuskeln drückst du das Gewicht ohne jeglichen Schwung nach vorne. Strecke jedoch deine Arme vorne nicht ganz durch, damit du die Spannung in den Muskeln nicht verlierst. Bleibe während der gesamten Ausführung mit deinem Oberkörper eng an der Rückenlehne und lasse ebenso deine Schultern hinten.";
    String butterflyBeschreibung =
        "Damit du effizient deinen großen Brustmuskel trainierst, solltest du die richtige Ausgangsposition einnehmen. Setze dich auf das Polster der Maschine und drücke deinen Rücken gegen die Lehne. Anschließend umfasst du beide Stangen im normalen Griff. Achte darauf, dass sich deine Arme parallel zum Boden befinden. Um deine Brustmuskulatur zu trainieren, sollten die Arme zudem auf der Höhe deiner Brust sein. Beide Füße stehen für einen stabilen Halt fest auf dem Boden. Du greifst beide Griffstangen und führst die Hände nach vorne. Bewege die Arme so weit, bis die Griffstangen vor der Brust zusammentreffen (oder kurz bevor sie sich berühren). Die Arme sollten fast durchgestreckt sein. Beim Zusammenführen der Arme vorne vor der Brust atmest du aus. Anschließend kannst du einatmen, während die Arme kontrolliert in die Ausgangsposition zurückkehren. Du stoppst mit der Bewegung, wenn sich deine Arme in einer Linie mit dem Körper befinden.";
    String latzugzurBrustB =
        "Die Ausgangsposition ist bei beiden Übungsvarianten gleich. Du setzt dich an den Latzug. Deine Füße stehen fest auf dem Boden. Oberschenkel und Wade befinden sich in einem rechten Winkel. Dein Körper ist aufrecht und du machst ein leichtes Hohlkreuz, um deinen unteren Rücken zu schützen. Dein Kopf schaut in Richtung des Latzugs und du bist nun bereit, um mit dem klassischen Latziehen zur Brust zu beginnen. Du schnappst dir mit beiden Händen im Obergriff die Stange des Latzugs. Beim Ausatmen ziehst du das Gewicht vor deinem Körper zur Brust nach unten. Du stoppst die Bewegung leicht oberhalb der Brust. Anschließend kehrst du beim Einatmen in die Ausgangsposition zurück.";
    String rudernamKabelB =
        "Bei dieser Fitnessübung nutzt den engen V-Griff. Das Kabel am Kabelzug befindet sich auf der Höhe deiner Brust. Beim Ausatmen ziehst du den V-Griff zu dir und leicht nach unten. Unter deiner Brust hältst du die Bewegung an und kehrst nach kurzem Verharren in die Ausgangsposition zurück. Dabei atmest du ein.";
    String seithebenKurzhantelnB =
        "Beim beidarmigen Kurzhantel-Seitheben im Stehen handelt es sich um den Klassiker. Achte darauf, dass du bei der Bewegungsausführung lediglich deine Arme bewegst. Der restliche Körper bleibt starr. Beim Ausatmen führst du beide Arme schwunglos nach oben. Stoppe erst, wenn sich die Arme auf der Höhe deiner Schultern und parallel über dem Boden befinden. Anschließend atmest du ein und kehrst mit den Armen bis zur Ausgangsposition zurück.";
    String szCurlsB =
        "Setze dich mit aufrechtem Oberkörper in das Gerät, bilde ein leichtes Hohlkreuz im unteren Rücken und lege deine Oberarme auf dem Armpolster der Maschine ab. Mit den Händen greifst du die Griffstücke oder die Stange im Untergriff. Wichtig ist, dass deine Ellenbogengelenke auf der gleichen Höhe wie das Drehgelenk der Maschine sind. Nur so ist eine perfekte Bewegungsausführung an diesem Gerät möglich.Während du ausatmest ziehst du die Stange oder die Griffe in Richtung deines Oberkörpers. Hierbei bewegt sich ausschließlich dein Unterarm, der über das Ellenbogengelenk nach vorne gebeugt wird. Der Rest des Körpers bleibt völlig regungslos.Im Anschluss atmest du ein und senkst die Stange oder die Griffe wieder nach vorne ab. Wichtig ist, dass du dabei deine Arme nicht komplett durchstreckst, sondern eine minimale Beugung im Arm beibehältst. Dies ist sehr zu empfehlen, wenn du deine Ellenbogengelenke schonen möchtest.Achtung: Durch die Schrägstellung des Polsters wird die Spannung in den Zielmuskeln bei der Übungsausführung wesentlich größer als bei den normalen Bizepscurls. Deshalb ist es sehr wichtig die Muskulatur vorher gut aufzuwärmen.";
    String trizepsdrueckenamKabelB =
        "Greife das Griffstück im Obergriff etwa hüftbreit und stelle dich möglichst nah im Stemmschritt oder mit schulterbreiter Beinstellung an den hohen Block des Kabelzugturms. Dein Oberkörper ist aufrecht und leicht nach vorne geneigt, dein Rücken ist gerade und deine Bauchmuskeln sind angespannt. Deine Ellenbogen sind eng am Oberkörper. Jetzt drückst du das Griffstück vertikal nach unten. Dabei atmest du aus. Deine Ellenbogen bleiben dabei permanent an gleicher Position, da sich nur deine Unterarme bewegen. Im Anschluss lässt du kontrolliert und langsam das Griffstück durch die Kraft des Zugseils wieder nach oben. Dabei atmest du ein.";
    String beinpresseB =
        "Setze dich auf das Sitzpolster der Beinpresse und lehne deinen Rücken an das Rückenpolster. Deine Füße platzierst du etwa hüftbreit auf die dafür vorgesehene Fußplatte. Weitere denkbare Fußstellungen und deren Wirkungsweisen bekommst du im Artikel Fußstellungen gezeigt und erklärt. Wenn das Gerät Griffstücke besitzt, kannst du zusätzliche Stabilität gewinnen, indem du dich an ihnen festhältst.Jetzt löst du die Sicherung und führst das Gewicht langsam und kontrolliert so weit wie möglich an den Oberkörper heran.Anschließend atmest du aus und drückst zeitgleich die Fußplatte über die Fersen deiner Beine wieder nach oben. Achte am Ende dieser Bewegung darauf, dass deine Beine nicht völlig durchgestreckt sind, um deine Kniegelenke nicht unnötig zu belasten. Deine Füße sollten so weit oben auf der Fußplatte positioniert sein, dass Knie und Fußspitze während der gesamten Übungsausführung eine gedachte Linie bilden.";
    String beincurlsB =
        "Das Fußpolster stellst du so ein wie bei der Fitness Übung zuvor. Teste die Ausführung anfangs mit leichtem Gewicht, um dich an das Training zu gewöhnen. Aus der Kraft deiner hinteren Oberschenkelmuskeln, ziehst du die Polsterung ohne Ruck nach oben. Kontrolliere die senkrechte Haltung deiner Unterschenkel im Spiegel und lasse sie dann wieder runter. Achte besonders darauf, dass du die Kraft bei den Curls, aus beiden Oberschenkeln gleichmäßig generierst. Unten streckst du die Beine wieder nicht vollständig, um die Muskelspannung nicht zu verlieren. Das Gewicht an dem Gerät, darf sich bei den Beincurls liegend zwischendurch ebenfalls nicht absetzen.";
    String crunchB =
        "Bei einem klassischen geraden Crunch legen Sie sich mit Ihrem Rücken auf den Boden. Winkeln Sie die Beine an (etwa 90 Grad), sodass diese im rechten Winkel zur Hüfte stehen. Die Arme zur Seite nehmen und mit den Fingerspitzen sachte die Schläfen berühren – und nicht am Kopf ziehen! Heben Sie nun mit der Kraft aus der Rumpfmuskulatur Ihren Oberkörper, bis die Schulterblätter den Boden nicht mehr berühren – mehr muss nicht sein. Den Rücken dabei möglichst gerade, den Kopf stets in der Linie Ihres Oberkörpers halten. Ein paar Sekunden die Endposition halten, dann Oberkörper langsam und kontrolliert absenken. In der niedrigsten Position stets die Muskelspannung im Bauch aufrechthalten. Wenn’s brennt, machen Sie es richtig. Tipp: Bei Bauchpressen mit angewinkelten Beinen die Fußspitzen anheben. Folge: Sie drücken die Fersen fester auf den Boden. " +
            "So tragen die Hilfsmuskeln kaum zu der Bewegung bei, was die Bauchmuskulatur stärker belastet";
    List<Uebung> tmpUebungs = [];
    tmpUebungs.add(Uebung(
        "Flachbankdrücken Maschine",
        flachbankdrueckenMaschineBeschreibung,
        'exercises/flachbankdruecken_Maschine.png',
        "#ac4bb4",
        "",
        "",
        4));
    tmpUebungs.add(Uebung("Butterfly", butterflyBeschreibung,
        'exercises/butterfly-maschine.jpg', "#ac4bb4", "", "", 4));
    tmpUebungs.add(Uebung("Latzug zur Brust", latzugzurBrustB,
        'exercises/latzugzurBrust.png', "#c5118d", "", "", 4));
    tmpUebungs.add(Uebung("Rudern am Kabel", rudernamKabelB,
        'exercises/rudern-am-kabelzug.gif', "#c5118d", "", "", 4));
    tmpUebungs.add(Uebung("Seitenheben Kurzhanteln", seithebenKurzhantelnB,
        'exercises/seitheben_mit_kurzhanteln.jpg', "#d32c60", "", "", 4));
    tmpUebungs.add(Uebung("Beinpresse", beinpresseB, 'exercises/beinpresse.gif',
        "#ffc41d", "", "", 4));
    tmpUebungs.add(Uebung("Beincurls", beincurlsB, 'exercises/beincurls.gif',
        "#ffc41d", "", "", 4));
    tmpUebungs.add(Uebung("Scottcurls am Gerät", szCurlsB,
        'exercises/scottcurls_maschine.jpg', "#a7eb7b", "", "", 4));
    tmpUebungs.add(Uebung("Trizepsdrücken am Kabel", trizepsdrueckenamKabelB,
        'exercises/trizepsdrückenamKabel.png', "#68d9f3", "", "", 4));
    tmpUebungs.add(Uebung("Bauchmaschine", crunchB, 'exercises/crunsh.jpeg',
        "#00718f", "", "", 4));
    List<TrainingPlan> tmp = [];
    tmp.add(new TrainingPlan("Komplett Workout", tmpUebungs));
    return tmp;
  }
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
