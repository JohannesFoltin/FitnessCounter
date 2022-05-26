import 'package:fitness_f/controller/controller.dart';
import 'package:fitness_f/models/datalayer.dart';
import 'package:fitness_f/views/onFitness.dart';
import 'package:fitness_f/views/testScreen.dart';
import 'package:fitness_f/views/trainingResult.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:fitness_f/views/trainingOverview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppDataController(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Georgia',
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
  @override
  Widget build(BuildContext context) {
    Widget? myWidget;
    if (Provider.of<AppDataController>(context).isloaded == false) {
      myWidget = CircularProgressIndicator();
    } else {
      myWidget = buildEverything(context);
    }
    return Scaffold(
      appBar: AppBar(
          title: Text("Fitness 3000",
              style: Theme.of(context).textTheme.headlineMedium)),
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
                Provider.of<AppDataController>(context, listen: false)
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
                                    trainingPlan:
                                        Provider.of<AppDataController>(context,
                                                listen: false)
                                            .appData
                                            .trainingsPlans
                                            .first,
                                  )));
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
                        if (Provider.of<AppDataController>(context,
                                listen: false)
                            .isTrainingEmpty()) {
                          print("No Trainings available");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrainingResult(
                                      training: Provider.of<AppDataController>(
                                              context,
                                              listen: false)
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrainingOverview()));
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
        Text(Provider.of<AppDataController>(context, listen: false)
            .appData
            .trainingsPlans
            .length
            .toString())
      ],
    ));
  }

  ichhassemeinLeben() async {
    Provider.of<AppDataController>(context, listen: false).appData =
        new AppData([], []);
    var prefs = await SharedPreferences.getInstance();
    prefs.clear().then((value) => {
          Provider.of<AppDataController>(context, listen: false).saveAppData(),
          setState(() {})
        });
    print("everything is restet");
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
