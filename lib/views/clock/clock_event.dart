part of 'clock_bloc.dart';

sealed class ClockEvent{
  const ClockEvent();
}

final class ClockStarted extends ClockEvent {
  const ClockStarted({required this.duration});
  final int duration;
}

final class ClockPaused extends ClockEvent {
  const ClockPaused();
}

final class ClockResumed extends ClockEvent {
  const ClockResumed();
}

class ClockReset extends ClockEvent {
  const ClockReset();
}

class _ClockTicked extends ClockEvent {
  const _ClockTicked({required this.duration});
  final int duration;
}
