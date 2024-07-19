import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    // Register the event handler for FetchWeather
    on<FetchWeather>(_onFetchWeather);
  }

  // Event handler for FetchWeather
  void _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.fetchWeather(event.cityName);
      emit(WeatherLoaded(weather: weather));
    } catch (_) {
      emit(WeatherError("Could not fetch weather. Is the device online?"));
    }
  }
}
