import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:equatable/equatable.dart';

class ResetWeather extends Equatable {
  final City location;
  final String lastUpdate;
  final Map<String, dynamic> preForecast;
  final Map<String, dynamic> preLocation;
  // Equatable allows for a simple value equality in Dart.
  // All you need to do is to pass the class fields to the super constructor.
  ResetWeather(
      {/*this.update*/ required this.location,
      this.preForecast = const {},
      required this.lastUpdate,
      this.preLocation = const {}});

  @override
  List<Object?> get props => [location, preForecast, preLocation, lastUpdate];
}
