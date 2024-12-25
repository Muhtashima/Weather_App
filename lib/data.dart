
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;

const apiKey = 'db459b548cea70c451b2fc8a9922af08';

Future<http.Response> fetchResponse(){
  return http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=db459b548cea70c451b2fc8a9922af08'));
}

Future<List<Document>> fetchDocuments() async{
  final response = await fetchResponse();
  if(response.statusCode == 200) {
    print(jsonDecode(response.body));
    return getDocuments(jsonDecode(response.body) as Map<String,dynamic>);
  }else{
    throw Exception('Failed to fetch document');
  }
}

List<Document> getDocuments(Map<String, dynamic> jsondocs){

  if(jsondocs.containsKey('main') && jsondocs['main'] is Map<String,dynamic>){
      return [for (final entry in jsondocs['main'].entries) Document.fromJson(entry)];
  }else{throw const FormatException('Unexpected map format');}
}

sealed class Document{
  Document();
  factory Document.fromJson(MapEntry<String, dynamic> entry) {

    switch (entry) {
      case MapEntry(key:'temp',value: double temperature):
        return TemperatureDocument(temperature: temperature);
      case MapEntry(key:'temp_min', value: double tempMin):
        return TempMinDocument(tempMin: tempMin);
      case MapEntry(key:'temp_max',value: double tempMax):
        return TempMaxDocument(tempMax: tempMax);
      case MapEntry(key:'feels_like',value: double feelsLike):
        return FeelsLikeDocument(feelsLike: feelsLike);
      case MapEntry(key:'pressure',value: int pressure):
        return PressureDocument(pressure: pressure);
      case MapEntry(key:'humidity',value: int humidity):
        return HumidityDocument(humidity: humidity);
      case MapEntry(key: 'sea_level', value: int seaLevel):
        print('Sea Level section matched');
        return SeaLevelDocument(seaLevel: seaLevel);
        case MapEntry(key: 'grnd_level', value: int grndLevel):
        print('ground level section matched');
        return GroundLevelDocument(grndLevel: grndLevel);
      default:
        throw const FormatException('Unexpected MapEntry');
    }
  }

}


class TemperatureDocument extends Document {
  final double temperature;
  TemperatureDocument({required this.temperature});
  @override
  String toString() => 'Temperature(id: $temperature)';
}

class FeelsLikeDocument extends Document {
  final double feelsLike;
  FeelsLikeDocument({required this.feelsLike});
  @override
  String toString() => 'feelsLike(id: $feelsLike)';
}

class TempMinDocument extends Document {
  final double tempMin;
  TempMinDocument({required this.tempMin});
  @override
  String toString() => 'tempMin(id: $tempMin)';
}

class TempMaxDocument extends Document {
  final double tempMax;
  TempMaxDocument({required this.tempMax});
  @override
  String toString() => 'tempMax(id: $tempMax)';
}

class PressureDocument extends Document {
  final int pressure;
  PressureDocument({required this.pressure});
  @override
  String toString() => 'Pressure(id: $pressure)';
}

class HumidityDocument extends Document {
  final int humidity;
  HumidityDocument({required this.humidity});
  @override
  String toString() => 'Humidity(id: $humidity)';
}

class SeaLevelDocument extends Document {
  final int seaLevel;
  SeaLevelDocument({required this.seaLevel});
  @override
  String toString() => 'Sea Level(id: $seaLevel)';
}
class GroundLevelDocument extends Document {
  final int grndLevel;
  GroundLevelDocument({required this.grndLevel});
  @override
  String toString() => 'Ground Level(id: $grndLevel)';

}

