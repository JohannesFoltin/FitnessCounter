import 'package:flutter/material.dart';
import 'package:fitness_f/controller/controller.dart';

class AppDataProvider extends InheritedWidget{
  final _controller = AppDataController();

  AppDataProvider({required Widget child}) : super(child: child);

  static AppDataController of(BuildContext context){
    AppDataProvider? result = context.dependOnInheritedWidgetOfExactType<AppDataProvider>();
    assert(result != null,'Error in appData_provider');
    return result!._controller;
  }
  @override
  bool updateShouldNotify(AppDataProvider old)=> _controller != old._controller;

}