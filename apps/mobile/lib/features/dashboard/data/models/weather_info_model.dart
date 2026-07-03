import '../../../dashboard/domain/entities/weather_info.dart';

class WeatherInfoModel extends WeatherInfo {
  const WeatherInfoModel({
    required super.condition,
    required super.temperature,
    required super.icon,
    required super.location,
  });

  factory WeatherInfoModel.fromJson(Map<String, dynamic> json) {
    return WeatherInfoModel(
      condition: json['condition'] as String? ?? '',
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      icon: json['icon'] as String? ?? '',
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'temperature': temperature,
      'icon': icon,
      'location': location,
    };
  }
}
