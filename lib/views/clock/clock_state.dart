part of 'clock_bloc.dart';

abstract class ClockState extends Equatable {
  const ClockState(this.time);
  final int time;

  @override
  List<Object> get props => [time];
}


final class ClockInitial extends ClockState {
  const ClockInitial(super.time);

  @override
  String toString() => 'TimerInitial { duration: $time }';
}

final class ClockRunPause extends ClockState {
  const ClockRunPause(super.time);

  @override
  String toString() => 'TimerRunPause { duration: $time }';
}

final class ClockRunInProgress extends ClockState {
  const ClockRunInProgress(super.time);

  @override
  String toString() => 'TimerRunInProgress { duration: $time }';
}
