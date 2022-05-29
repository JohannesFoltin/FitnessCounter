import 'package:fitness_f/controller/controller.dart';
import 'package:fitness_f/views/onFitness.dart';
import 'package:fitness_f/views/trainingResult.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:intl/intl.dart';

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
      myWidget = _pages.elementAt(_selectedIndex);
    }
    return Scaffold(
      appBar: AppBar(
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
          title: Text("Fitness 3000",
              style: Theme.of(context).textTheme.headlineMedium)),
      body: myWidget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Trainings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'RecentTrainings',
          )
        ],
      ),
    );
  }

  int _selectedIndex = 0;
  final _pages = [
    TrainingSelector(),
    RecentTrainings(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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

class TrainingSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<AppDataController>(context).appData;
    return Container(
      child: ListView.builder(
        itemCount: Provider.of<AppDataController>(context)
            .appData
            .trainingsPlans
            .length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.fromLTRB(5.0, 2.5, 5.0, 2.5),
            child: Container(
              child: ExpansionTile(
                  trailing: null,
                  title: Text(controller.trainingsPlans[index].name),
                  children: [
                    Text("Anzahl Übungen: " +
                        controller.trainingsPlans[index].exercises.length
                            .toString()),

                    //Text("Letzte Laenge" + controller.trainings.lastWhere((element) => element.name == controller.trainingsPlans[index].name).name??"Null")
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OnFitness(
                                        trainingPlan:
                                            Provider.of<AppDataController>(
                                                    context,
                                                    listen: false)
                                                .appData
                                                .trainingsPlans[index],
                                      )));
                        },
                        child: Text("Start"))
                  ]),
            ),
          );
        },
      ),
    );
  }
}

class RecentTrainings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Absolvierte Trainings diesen Monat: " +
                    Provider.of<AppDataController>(context, listen: false)
                        .getTrainingsThisMonth(DateTime.now())
                        .toString(),
              ).fontSize(18).center(),
              Text("Gesamt Anzahl Trainings: " +
                  Provider.of<AppDataController>(context, listen: false)
                      .appData
                      .trainingsPlans
                      .length
                      .toString()),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: Provider.of<AppDataController>(context, listen: false)
                .appData
                .trainings
                .length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  width: 100,
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: ElevatedButton(
                    child: Text(
                      "Training am: " +
                          DateFormat("dd.MM.yyyy mm:hh")
                              .format(Provider.of<AppDataController>(context,
                                      listen: false)
                                  .appData
                                  .trainings[index]
                                  .date)
                              .toString(),
                    ),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrainingResult(
                                  training: Provider.of<AppDataController>(
                                          context,
                                          listen: false)
                                      .appData
                                      .trainings[index])))
                    },
                  ));
            },
          ),
        )
      ],
    );
  }
}
