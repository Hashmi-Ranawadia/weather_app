import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../repositories/firebase_repository.dart';
import '../models/weather_model.dart';

class WeatherScreen extends StatelessWidget {
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  final TextEditingController cityController = TextEditingController();

  WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.3, 0.3),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          BlocProvider.of<WeatherBloc>(context)
                              .add(FetchWeather(cityName: cityController.text));
                        },
                        controller: cityController,
                        decoration: InputDecoration(
                          hintText: "Search City",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<WeatherBloc>(context)
                            .add(FetchWeather(cityName: cityController.text));
                      },
                      child: Icon(
                        Icons.search_rounded,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return CircularProgressIndicator();
                  } else if (state is WeatherLoaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.3, 0.3),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/temp.png",
                                  width: 40,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${state.weather.temperature}°C",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Temperature",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.3, 0.3),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/humi.png",
                                  width: 40,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${state.weather.humidity}%",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Humidity",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.3, 0.3),
                                  blurRadius: 10,
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/windspeed.png",
                                  width: 70,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${state.weather.windSpeed}km/h",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  "Wind Speed",
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Text(state.message);
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Weather History",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.blue),
                  )),
              const SizedBox(
                height: 8,
              ),
              StreamBuilder<List<Weather>>(
                stream: firebaseRepository.getWeather(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final weatherList = snapshot.data!;
                    return weatherList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemCount: weatherList.length,
                            itemBuilder: (context, index) {
                              final weather = weatherList[index];
                              return Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0.3, 0.3),
                                        blurRadius: 10,
                                      )
                                    ]),
                                child: ListTile(
                                  title: Text(weather.cityName),
                                  subtitle: Text(
                                      'Temp: ${weather.temperature}°C, ${weather.description}, Humidity: ${weather.humidity}%'),
                                  trailing: Image.asset(
                                    "assets/images/cloud.png",
                                    width: 40,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.20),
                            child: Text("Oop's no history found!"),
                          );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoaded) {
            return FloatingActionButton(
              onPressed: () {
                firebaseRepository.addWeather(state.weather);
              },
              child: Icon(Icons.cloud_upload_outlined),
            );
          } else if (state is WeatherError) {
            return SizedBox.shrink();
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
