import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:workout_stopwatch/service_locator.dart';
import 'package:workout_stopwatch/widgets/workout_list_screen.dart';

Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());
  setupServiceLocator();
  runApp(const WorkoutListScreen());
}


