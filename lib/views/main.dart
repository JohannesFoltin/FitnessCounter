import 'package:fitness_f/controller/controller.dart';
import 'package:fitness_f/views/onFitness.dart';
import 'package:fitness_f/views/settings.dart';
import 'package:fitness_f/views/showTimer.dart';
import 'package:fitness_f/views/trainingResult.dart';
import 'package:fitness_f/views/trainingsPlanEditor.dart';
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
      myWidget = Center(child: CircularProgressIndicator());
    } else {
      myWidget = _pages.elementAt(_selectedIndex);
    }
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowTimer(starttime: 90,)));
                },
                icon: Icon(Icons.settings))
          ],
          title: Text(
            "Fitness 3000",
          )),
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


class TrainingSelector extends StatefulWidget {
  @override
  State<TrainingSelector> createState() => _TrainingSelectorState();
}

class _TrainingSelectorState extends State<TrainingSelector> {
  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<AppDataController>(context).appData;
    return Container(
      child: Column(
        children: [
          Expanded(
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

                          //Text("Letzte Laenge: " + controller.trainings.lastWhere((element) => element.name == controller.trainingsPlans[index].name).dauer.toString()),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TrainingsPlanEditor(
                                                      trainingPlan: controller
                                                              .trainingsPlans[
                                                          index]),
                                            ))
                                        .then((value) => {
                                              Provider.of<AppDataController>(
                                                      context)
                                                  .saveAppData()
                                            });
                                    setState(() {});
                                  },
                                  child: Text("Edit")),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OnFitness(
                                                  trainingPlan: Provider.of<
                                                              AppDataController>(
                                                          context,
                                                          listen: false)
                                                      .appData
                                                      .trainingsPlans[index],
                                                )));
                                  },
                                  child: Text("Start")),
                            ],
                          )
                        ]),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {}, child: Text("Traingsplan erstellen")),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OnFitness(trainingPlan: null)));
                  },
                  child: Text("Freies Training")),
            ],
          )
        ],
      ),
    );
  }
}

class RecentTrainings extends StatefulWidget {
  @override
  State<RecentTrainings> createState() => _RecentTrainingsState();
}

class _RecentTrainingsState extends State<RecentTrainings> {
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
                          DateFormat("dd.MM.yyyy hh:mm")
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
