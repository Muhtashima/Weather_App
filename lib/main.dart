import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String apiKey ='db459b548cea70c451b2fc8a9922af08';
  String city = 'Dhaka';
  double? temperature;
  double? feelsLike;
  int? humidity;


  Future<void> fetchWeather() async{

    final url = Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Dhaka,bd&APPID=db459b548cea70c451b2fc8a9922af08');

    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = json.decode(response.body);
      print(data);
      setState(() {
        temperature = (data['main']['temp'] - 273.15);
        humidity = data['main']['humidity'];
        feelsLike = data['main']['feels_like'] - 273.15;
      });
    }else{
      throw Exception('failed to retrieve weather data');
    }
  }

  @override
  void initState(){
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: temperature != null ? Text('Temperature in $city: ${temperature!.toStringAsFixed(2)} C \nHumidity : ${humidity!.toString()} \nFeels Like : ${feelsLike!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, color: Colors.purpleAccent),) : const CircularProgressIndicator(),
      ),
    );
  }
}

