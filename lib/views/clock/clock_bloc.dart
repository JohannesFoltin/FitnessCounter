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
        super(ClockInitial(_time)) {
    on<ClockEvent>((event, emit) {
      // TODO: implement event handler
    });
  }

  final TickerUp _ticker;
  static const int _time = 0;
  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(ClockStarted event, Emitter<ClockState> emit) {
    emit(ClockRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker.tick(ticks: event.duration).listen((event) {
      add(_ClockTicked(duration: event));
    });
  }

  void _onPaused(ClockPaused event, Emitter<ClockState> emit) {
    if (state is ClockRunInProgress) {
      _tickerSubscription?.pause();
      emit(ClockRunPause(state.time));
    }
  }
  void _onTicked(_ClockTicked event, Emitter<ClockState> emit) {
    emit(ClockRunInProgress(event.duration));
  }

}
