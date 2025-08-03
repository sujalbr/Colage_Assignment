import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this to pubspec.yaml: intl: ^0.18.0
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // Dynamic current time
    final now = DateTime.now();
    final formattedTime = DateFormat('hh:mm a').format(now); // e.g., "01:30 PM"
    final formattedDate = DateFormat('MMMM d, yyyy').format(now); // e.g., "July 25, 2023" for list items

    // Normalize temperature for gauge progress (assuming range 10-30°C as in image)
    final minTemp = 10.0; // Dummy; replace with weather.minTemp if added to model
    final maxTemp = 30.0; // Dummy; replace with weather.maxTemp
    final progress = (weather.temperature - minTemp) / (maxTemp - minTemp).clamp(0.0, 1.0);

    // Determine label based on description (adapt available data)
    String getLabel(double temp) {
      if (weather.description.toLowerCase().contains('clear')) return 'Great';
      if (temp < 20) return 'Bad';
      return 'Unexpected';
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white, // White background like in the image
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            // Title with subtle icon
            Row(
              children: [
                Text(
                  'Temperature in ${weather.city}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                Image.network(
                  'http://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  width: 24,
                  height: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Circular Gauge
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: progress, // Based on temperature
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${weather.temperature}°C',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      // const Text('Goal 30°C', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Positioned(
                    left: 0,
                    bottom: 50,
                    child: Row(
                      children: [
                        const Icon(Icons.remove_circle_outline, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text('${minTemp.toInt()}°C', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 50,
                    child: Row(
                      children: [
                        Text('${maxTemp.toInt()}°C', style: const TextStyle(color: Colors.grey)),
                        const SizedBox(width: 4),
                        const Icon(Icons.add_circle_outline, color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Time Display
            Center(
              child: Text(
                'Time: $formattedTime',
                style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // List of Items (Adapted from available data; use dummies for simulation)
            _buildListItem(
              isChecked: true, // Example; make dynamic if needed
              temp: weather.temperature.toInt(),
              label: getLabel(weather.temperature), // Based on description
              timestamp: '$formattedTime, $formattedDate',
            ),
            _buildListItem(
              isChecked: false,
              temp: 20, // Dummy; replace with real data (e.g., from model extension)
              label: 'Bad',
              timestamp: '$formattedTime, $formattedDate',
            ),
            _buildListItem(
              isChecked: false,
              temp: 20, // Dummy
              label: 'Unexpected',
              timestamp: '$formattedTime, $formattedDate',
            ),
          ],
        ),
      ),
    );
  }

  // Helper for list items
  Widget _buildListItem({
    required bool isChecked,
    required int temp,
    required String label,
    required String timestamp,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: null, // Read-only for now; add logic if needed
            activeColor: Colors.blue,
          ),
          Text('$temp°C ($label)', style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(timestamp, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}