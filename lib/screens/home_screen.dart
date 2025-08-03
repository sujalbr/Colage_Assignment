import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../services/firestore_service.dart';
import '../models/weather_model.dart';
import '../widgets/weather_card.dart';
import '../widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final FirestoreService _firestoreService = FirestoreService();

  Weather? _weather;
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false; // New: State for toggling search bar
  String? _errorMessage; // New: For handling errors

  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter a city');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
    });

    try {
      final weather = await _weatherService.fetchWeather(_cityController.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
      if (weather != null) {
        await _firestoreService.saveCity(weather.city);
      } else {
        setState(() => _errorMessage = 'Failed to fetch weather data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _cityController.clear(); // Optional: Clear input when closing
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50], // Light orange background as requested
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _cityController,
                autofocus: true,
                onSubmitted: (_) => _fetchWeather(), // Trigger search on Enter
                decoration: InputDecoration(
                  hintText: 'Enter city',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              )
            : const Text(
                'W_App', // Main title (left-aligned)
                style: TextStyle(color: Colors.white),
              ),
        backgroundColor: Colors.orange[800], // Deep orange AppBar background
        elevation: 4,
        centerTitle: false, // Left-aligned title
        actions: [
          // "W_App" on the right side
         
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: _toggleSearch, // Toggle search bar
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: _isLoading
                    ? const LoadingWidget()
                    : _errorMessage != null
                        ? Center(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          )
                        : _weather != null
                            ? WeatherCard(weather: _weather!) // Safe with checks
                            : const Center(
                                child: Text(
                                  'No weather data available. Search for a city!',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}