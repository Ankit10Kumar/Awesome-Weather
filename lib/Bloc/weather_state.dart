import 'package:awesomeweather/WeatherModals/forcast.dart';
import 'package:awesomeweather/WeatherModals/locations.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WeatherState extends Equatable {
  WeatherState([List props = const <dynamic>[]]) : super();
}

class WeatherInitial extends WeatherState {
  @override
  List<Object?> get props => [];
}

class WeatherLoading extends WeatherState {
  @override
  List<Object?> get props => [];
}

// Only the WeatherLoaded event needs to contain data
class WeatherLoaded extends WeatherState {
  final Forecast forecast;
  final City location;
  final String lastUpdate;
  WeatherLoaded(this.forecast, this.location, this.lastUpdate)
      : super([forecast, location, lastUpdate]);

  @override
  List<Object?> get props => [forecast, location];
}

class WeatherError extends WeatherState {
  final String error;
  final String lastUpdate;
  final Map<String, dynamic> preForecast;
  final Map<String, dynamic> preLocation;
  WeatherError(
      {required this.error,
      required this.lastUpdate,
      required this.preForecast,
      required this.preLocation})
      : super([error, preForecast, preLocation, lastUpdate]);
  @override
  List<Object?> get props => [error];
}
