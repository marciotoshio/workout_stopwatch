import 'package:get_it/get_it.dart';
import 'package:workout_stopwatch/services/workout_service.dart';

final getIt = GetIt.instance;

setupServiceLocator() {
  // getIt.registerLazySingleton<WorkoutService>(() => MemoryWorkoutService());
  getIt.registerLazySingleton<WorkoutService>(() => SqlWorkoutService());
}
