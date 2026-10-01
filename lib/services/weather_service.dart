import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherService {
  Future<Weather> getWeather() async {
    final url = Uri.parse(
      'https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=35.73.05.1008',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Weather.fromJson(data);
    } else {
      throw Exception(
        'Gagal mengambil data cuaca: ${response.statusCode}',
      );
    }
  }
}
