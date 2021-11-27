import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:workout_stopwatch/widgets/workout_screen.dart';
import 'models/workout.dart';
import 'widgets/app_settings.dart';

Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());

  var getReadyTime = int.parse(Settings.getValue<String>(AppSettings.keyGetReadyTime, "5"));
  var workoutTime = int.parse(Settings.getValue<String>(AppSettings.keyWorkoutTime, "30"));
  var restTime = int.parse(Settings.getValue<String>(AppSettings.keyRestTime, "10"));

  var workout = Workout(1, "Workout 1", getReadyTime, workoutTime, restTime);

  runApp(WorkoutScreen(workout: workout));
}
