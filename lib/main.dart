import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: WeatherView(),
      ),
    );
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  bool tempera = true;
  late final Future<List<Document>> futureDocuments;

  @override
  void initState() {
    super.initState();
    // Your initialization code here
    futureDocuments = fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Document>>(
      future: futureDocuments,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) =>
                DocumentWidget(document: snapshot.data![index]),

          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

class DocumentWidget extends StatelessWidget {
  final Document document;

  const DocumentWidget({required this.document, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.red,
      child: switch (document) {
        TemperatureDocument(:double temperature) =>
            Text('Temperature $temperature'),
        TempMinDocument(:double tempMin) =>
            Text('Minimum Temperature $tempMin'),
        TempMaxDocument(:double tempMax) =>
            Text('Maximum Temperature $tempMax'),
        FeelsLikeDocument(:double feelsLike) =>
            Text('Feels like $feelsLike'),
        HumidityDocument(:int humidity) =>
            Text('Humidity $humidity'),
        PressureDocument(:int pressure) =>
            Text('Pressure $pressure'),
        SeaLevelDocument(:int seaLevel) =>
            Text('Sea Level $seaLevel'),
        GroundLevelDocument(:int grndLevel) =>
            Text('Ground Level $grndLevel')
      },
    );
  }
}
