import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = WeatherService();

    return Scaffold(
      body: FutureBuilder<Weather>(
        future: service.getWeather(),
        builder: (context, snapshot) {
          // 1. Sedang mengambil data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2. Terjadi error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
              ),
            );
          }

          // 3. Data tidak tersedia
          final data = snapshot.data;

          if (data == null) {
            return const Center(
              child: Text('Data tidak tersedia'),
            );
          }

          // 4. Mencari prakiraan pertama yang waktunya
          //    masih sama atau setelah waktu sekarang
          Forecast? currentForecast;

          final sekarang = DateTime.now();

          for (final forecast in data.forecasts) {
            final waktuForecast = DateTime.parse(forecast.jam);

            if (waktuForecast.isAfter(sekarang) ||
                waktuForecast.isAtSameMomentAs(sekarang)) {
              currentForecast = forecast;
              break;
            }
          }

          if (currentForecast == null) {
            return const Center(
              child: Text('Tidak ada data prakiraan'),
            );
          }

          // 5. Mencari posisi currentForecast
          final currentIndex = data.forecasts.indexOf(currentForecast);

          // 6. Memastikan masih ada minimal 3 data
          if (currentIndex + 2 >= data.forecasts.length) {
            return const Center(
              child: Text('Data prakiraan tidak mencukupi'),
            );
          }

          // 7. Mengambil 3 prakiraan mulai dari currentForecast
          final forecasts = data.forecasts.sublist(
            currentIndex,
            currentIndex + 3,
          );

          // 8. Menampilkan GUI
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  data.lokasi,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${currentForecast.suhu}°C',
                      style: const TextStyle(
                        fontSize: 45,
                      ),
                    ),
                    SvgPicture.network(
                      currentForecast.image,
                      width: 125,
                      height: 125,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ForecastCard(
                      forecast: forecasts[0],
                    ),
                    ForecastCard(
                      forecast: forecasts[1],
                    ),
                    ForecastCard(
                      forecast: forecasts[2],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          forecast.jam.substring(11, 16),
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SvgPicture.network(
          forecast.image,
          width: 50,
          height: 50,
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          '${forecast.suhu}°C',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
