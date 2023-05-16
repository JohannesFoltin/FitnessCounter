import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/uebungsErgebniss.dart';

part 'overview_exercise_results_event.dart';
part 'overview_exercise_results_state.dart';

class OverviewExerciseResultsBloc extends Bloc<OverviewExerciseResultsEvent, OverviewExerciseResultsState> {
  OverviewExerciseResultsBloc() : super(OverviewExerciseResultsInitial()) {
    on<OverviewExerciseResultsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
