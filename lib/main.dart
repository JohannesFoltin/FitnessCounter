import 'package:fitness_f/onFitness.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => onFitness(items: [
              CardItem("Flachbankdrücken Maschine", flachbankdruecken_Maschine_Beschreibung,AssetImage('exercises/flachbankdruecken_Maschine.png')),
              CardItem("Butterfly", butterflyBeschreibung,AssetImage('exercises/butterfly-maschine.jpg')),
              CardItem("Latzug zur Brust",latzugzurBrustB,AssetImage('exercises/latzugzurBrust.png')),
              CardItem("Rudern am Kabel",rudernamKabelB,AssetImage('exercises/rudern-am-kabelzug.gif')),
              CardItem("Seitheben Kurzhanteln",seithebenKurzhantelnB,AssetImage('exercises/seitenheben_mit_kurzhanteln.jpg')),
              CardItem("Scottcurls am Gerät",szCurlsB,AssetImage('exercises/scottcurls_maschine.jpg')),
              CardItem("Trizepsdrücken am Kabel",trizepsdrueckenamKabelB,AssetImage('exercises/trizepsdrückenamKabel.png')),
              CardItem("Beinpresse",beinpresseB,AssetImage('exercises/beinpresse.gif')),
              CardItem("Beincurls",beincurlsB,AssetImage('exercises/beincurls.gif')),
              CardItem("Crunch",crunchB,AssetImage('exercises/crunsh.png')),
            ],))
          );
        },
        child: Text("Start Training"),
        )
      ),
    );
  }

  String flachbankdruecken_Maschine_Beschreibung = "Wir greifen den horizontalen Griff so weit außen wie möglich, damit wir so stark wie nur möglich die Brust trainieren. Je enger wir greifen, desto verstärkt belasten wir den Trizeps, wie bei der Übung enges Bankdrücken. Stelle den Sitz für das Training so ein, dass die Griffe auf der Höhe deiner Brust sind. Aus der Kraft der Brustmuskeln drückst du das Gewicht ohne jeglichen Schwung nach vorne. Strecke jedoch deine Arme vorne nicht ganz durch, damit du die Spannung in den Muskeln nicht verlierst. Bleibe während der gesamten Ausführung mit deinem Oberkörper eng an der Rückenlehne und lasse ebenso deine Schultern hinten.";
  String butterflyBeschreibung= "Damit du effizient deinen großen Brustmuskel trainierst, solltest du die richtige Ausgangsposition einnehmen. Setze dich auf das Polster der Maschine und drücke deinen Rücken gegen die Lehne. Anschließend umfasst du beide Stangen im normalen Griff. Achte darauf, dass sich deine Arme parallel zum Boden befinden. Um deine Brustmuskulatur zu trainieren, sollten die Arme zudem auf der Höhe deiner Brust sein. Beide Füße stehen für einen stabilen Halt fest auf dem Boden. Du greifst beide Griffstangen und führst die Hände nach vorne. Bewege die Arme so weit, bis die Griffstangen vor der Brust zusammentreffen (oder kurz bevor sie sich berühren). Die Arme sollten fast durchgestreckt sein. Beim Zusammenführen der Arme vorne vor der Brust atmest du aus. Anschließend kannst du einatmen, während die Arme kontrolliert in die Ausgangsposition zurückkehren. Du stoppst mit der Bewegung, wenn sich deine Arme in einer Linie mit dem Körper befinden.";
  String latzugzurBrustB = "Die Ausgangsposition ist bei beiden Übungsvarianten gleich. Du setzt dich an den Latzug. Deine Füße stehen fest auf dem Boden. Oberschenkel und Wade befinden sich in einem rechten Winkel. Dein Körper ist aufrecht und du machst ein leichtes Hohlkreuz, um deinen unteren Rücken zu schützen. Dein Kopf schaut in Richtung des Latzugs und du bist nun bereit, um mit dem klassischen Latziehen zur Brust zu beginnen. Du schnappst dir mit beiden Händen im Obergriff die Stange des Latzugs. Beim Ausatmen ziehst du das Gewicht vor deinem Körper zur Brust nach unten. Du stoppst die Bewegung leicht oberhalb der Brust. Anschließend kehrst du beim Einatmen in die Ausgangsposition zurück.";
  String rudernamKabelB = "Bei dieser Fitnessübung nutzt den engen V-Griff. Das Kabel am Kabelzug befindet sich auf der Höhe deiner Brust. Beim Ausatmen ziehst du den V-Griff zu dir und leicht nach unten. Unter deiner Brust hältst du die Bewegung an und kehrst nach kurzem Verharren in die Ausgangsposition zurück. Dabei atmest du ein.";
  String seithebenKurzhantelnB = "Beim beidarmigen Kurzhantel-Seitheben im Stehen handelt es sich um den Klassiker. Achte darauf, dass du bei der Bewegungsausführung lediglich deine Arme bewegst. Der restliche Körper bleibt starr. Beim Ausatmen führst du beide Arme schwunglos nach oben. Stoppe erst, wenn sich die Arme auf der Höhe deiner Schultern und parallel über dem Boden befinden. Anschließend atmest du ein und kehrst mit den Armen bis zur Ausgangsposition zurück.";
  String szCurlsB = "Setze dich mit aufrechtem Oberkörper in das Gerät, bilde ein leichtes Hohlkreuz im unteren Rücken und lege deine Oberarme auf dem Armpolster der Maschine ab. Mit den Händen greifst du die Griffstücke oder die Stange im Untergriff. Wichtig ist, dass deine Ellenbogengelenke auf der gleichen Höhe wie das Drehgelenk der Maschine sind. Nur so ist eine perfekte Bewegungsausführung an diesem Gerät möglich.Während du ausatmest ziehst du die Stange oder die Griffe in Richtung deines Oberkörpers. Hierbei bewegt sich ausschließlich dein Unterarm, der über das Ellenbogengelenk nach vorne gebeugt wird. Der Rest des Körpers bleibt völlig regungslos.Im Anschluss atmest du ein und senkst die Stange oder die Griffe wieder nach vorne ab. Wichtig ist, dass du dabei deine Arme nicht komplett durchstreckst, sondern eine minimale Beugung im Arm beibehältst. Dies ist sehr zu empfehlen, wenn du deine Ellenbogengelenke schonen möchtest.Achtung: Durch die Schrägstellung des Polsters wird die Spannung in den Zielmuskeln bei der Übungsausführung wesentlich größer als bei den normalen Bizepscurls. Deshalb ist es sehr wichtig die Muskulatur vorher gut aufzuwärmen.";
  String trizepsdrueckenamKabelB = "Greife das Griffstück im Obergriff etwa hüftbreit und stelle dich möglichst nah im Stemmschritt oder mit schulterbreiter Beinstellung an den hohen Block des Kabelzugturms. Dein Oberkörper ist aufrecht und leicht nach vorne geneigt, dein Rücken ist gerade und deine Bauchmuskeln sind angespannt. Deine Ellenbogen sind eng am Oberkörper. Jetzt drückst du das Griffstück vertikal nach unten. Dabei atmest du aus. Deine Ellenbogen bleiben dabei permanent an gleicher Position, da sich nur deine Unterarme bewegen. Im Anschluss lässt du kontrolliert und langsam das Griffstück durch die Kraft des Zugseils wieder nach oben. Dabei atmest du ein.";
  String beinpresseB = "Setze dich auf das Sitzpolster der Beinpresse und lehne deinen Rücken an das Rückenpolster. Deine Füße platzierst du etwa hüftbreit auf die dafür vorgesehene Fußplatte. Weitere denkbare Fußstellungen und deren Wirkungsweisen bekommst du im Artikel Fußstellungen gezeigt und erklärt. Wenn das Gerät Griffstücke besitzt, kannst du zusätzliche Stabilität gewinnen, indem du dich an ihnen festhältst.Jetzt löst du die Sicherung und führst das Gewicht langsam und kontrolliert so weit wie möglich an den Oberkörper heran.Anschließend atmest du aus und drückst zeitgleich die Fußplatte über die Fersen deiner Beine wieder nach oben. Achte am Ende dieser Bewegung darauf, dass deine Beine nicht völlig durchgestreckt sind, um deine Kniegelenke nicht unnötig zu belasten. Deine Füße sollten so weit oben auf der Fußplatte positioniert sein, dass Knie und Fußspitze während der gesamten Übungsausführung eine gedachte Linie bilden.";
  String beincurlsB="Das Fußpolster stellst du so ein wie bei der Fitness Übung zuvor. Teste die Ausführung anfangs mit leichtem Gewicht, um dich an das Training zu gewöhnen. Aus der Kraft deiner hinteren Oberschenkelmuskeln, ziehst du die Polsterung ohne Ruck nach oben. Kontrolliere die senkrechte Haltung deiner Unterschenkel im Spiegel und lasse sie dann wieder runter. Achte besonders darauf, dass du die Kraft bei den Curls, aus beiden Oberschenkeln gleichmäßig generierst. Unten streckst du die Beine wieder nicht vollständig, um die Muskelspannung nicht zu verlieren. Das Gewicht an dem Gerät, darf sich bei den Beincurls liegend zwischendurch ebenfalls nicht absetzen.";
  String crunchB = "Bei einem klassischen geraden Crunch legen Sie sich mit Ihrem Rücken auf den Boden. Winkeln Sie die Beine an (etwa 90 Grad), sodass diese im rechten Winkel zur Hüfte stehen. Die Arme zur Seite nehmen und mit den Fingerspitzen sachte die Schläfen berühren – und nicht am Kopf ziehen! Heben Sie nun mit der Kraft aus der Rumpfmuskulatur Ihren Oberkörper, bis die Schulterblätter den Boden nicht mehr berühren – mehr muss nicht sein. Den Rücken dabei möglichst gerade, den Kopf stets in der Linie Ihres Oberkörpers halten. Ein paar Sekunden die Endposition halten, dann Oberkörper langsam und kontrolliert absenken. In der niedrigsten Position stets die Muskelspannung im Bauch aufrechthalten. Wenn’s brennt, machen Sie es richtig. Tipp: Bei Bauchpressen mit angewinkelten Beinen die Fußspitzen anheben. Folge: Sie drücken die Fersen fester auf den Boden. "+"So tragen die Hilfsmuskeln kaum zu der Bewegung bei, was die Bauchmuskulatur stärker belastet";
}

