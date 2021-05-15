import 'package:injectable/injectable.dart';

mixin OnTrackStarted {
  void onTrackStarted();

  void onTrackFinished(double trackedHours);
}

mixin OnWattHoursCalculated {
  void onWattHoursCalculated(double wattHours);
}

@lazySingleton
class WattCollector {
  OnTrackStarted onTrackStarted;

  OnWattHoursCalculated onWattHoursCalculated;

  double watts = 0;

  startTrack() => onTrackStarted.onTrackStarted();

  finishTrack(double trackedHours) =>
      onTrackStarted.onTrackFinished(trackedHours);

  sendCalculatedWattHours(double wattHours) =>
      onWattHoursCalculated.onWattHoursCalculated(wattHours);
}
