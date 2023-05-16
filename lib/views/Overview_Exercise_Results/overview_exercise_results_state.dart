part of 'overview_exercise_results_bloc.dart';

import '../../models/uebungsErgebniss.dart';


abstract class OverviewExerciseResultsState extends Equatable {
  const OverviewExerciseResultsState();
  final List<UebungsErgebniss> test;
}

class OverviewExerciseResultsInitial extends OverviewExerciseResultsState {
  @override
  List<Object> get props => [];
}
