import 'package:equatable/equatable.dart';

class WeatherInfo extends Equatable {
  final String condition;
  final double temperature;
  final String icon;
  final String location;

  const WeatherInfo({
    required this.condition,
    required this.temperature,
    required this.icon,
    required this.location,
  });

  @override
  List<Object?> get props => [condition, temperature, icon, location];
}
