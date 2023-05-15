import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_f/views/ticker.dart';
import 'package:flutter/cupertino.dart';

part 'clock_event.dart';
part 'clock_state.dart';

class ClockBloc extends Bloc<ClockEvent, ClockState> {
  ClockBloc({required TickerUp ticker})
    : _ticker = ticker,
    super(ClockInitial(_time)){
      on<ClockEvent>((event, emit) {
      // TODO: implement event handler
     });
  }


  final TickerUp _ticker;
  static const int _time = 0;
}
