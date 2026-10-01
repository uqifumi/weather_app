class Forecast {
  final String jam;
  final int suhu;
  final String deskripsi;
  final String image;

  Forecast({
    required this.jam,
    required this.suhu,
    required this.deskripsi,
    required this.image,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      jam: json['local_datetime'],
      suhu: json['t'],
      deskripsi: json['weather_desc'],
      image: json['image'],
    );
  }
}

class Weather {
  final String lokasi;
  final List<Forecast> forecasts;

  Weather({
    required this.lokasi,
    required this.forecasts,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final cuaca = json['data'][0]['cuaca'][0];

    final forecasts = cuaca.map<Forecast>((item) {
      return Forecast.fromJson(item);
    }).toList();

    return Weather(
      lokasi: json['lokasi']['desa'],
      forecasts: forecasts,
    );
  }
}
