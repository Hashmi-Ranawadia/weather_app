import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/weather_model.dart';

class FirebaseRepository {
  final CollectionReference weatherCollection = FirebaseFirestore.instance.collection('weather');

  Future<void> addWeather(Weather weather) {
    return weatherCollection.add(weather.toJson());
  }

  Stream<List<Weather>> getWeather() {
    return weatherCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Weather(
          cityName: doc['cityName'],
          temperature: doc['temperature'],
          description: doc['description'],
          humidity: doc['humidity'],
          windSpeed: doc['speed'],
        );
      }).toList();
    });
  }
}
