import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'app_settings.dart';
import 'timer.dart';
import '../models/workout.dart';

class WorkoutScreen extends StatelessWidget {
  final Workout workout;
  const WorkoutScreen({Key? key, required this.workout}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: workout.name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutPage(workout: workout),
    );
  }
}

class WorkoutPage extends StatefulWidget {
  final Workout workout;
  const WorkoutPage({Key? key, required this.workout}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  GlobalKey getReadyTimerKey = GlobalKey();
  GlobalKey workoutTimerKey = GlobalKey();
  GlobalKey restTimerKey = GlobalKey();

  bool playNotificationSound = false;

  @override
  void initState() {
    super.initState();

    getSettings();
  }

  void refresh() {
    setState(getSettings);
  }

  void getSettings() {
    playNotificationSound = Settings.getValue<bool>(AppSettings.keyNotificationSound, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.workout.name),
      ),
      body: Column(
        children: <Widget>[
          Timer(
            key: getReadyTimerKey,
            timer: StopWatchTimer(
              mode: StopWatchMode.countDown,
              onEnded: handleGetReadyEnded,
            ),
            time: widget.workout.getReadyTime,
            color: Colors.lightBlue,
          ),
          Timer(
            key: workoutTimerKey,
            timer: StopWatchTimer(
              mode: StopWatchMode.countDown,
              onEnded: handleWorkoutEnded,
            ),
            time: widget.workout.workoutTime,
            color: Colors.blue,
          ),
          Timer(
            key: restTimerKey,
            timer: StopWatchTimer(
              mode: StopWatchMode.countDown,
              onEnded: handleRestEnded,
            ),
            time: widget.workout.restTime,
            color: Colors.blueGrey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var getReadyTimerWidget = getReadyTimerKey.currentWidget as Timer;
          getReadyTimerWidget.start();
        },
        tooltip: 'Start',
        child: const Icon(Icons.play_circle_outline),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      drawer: Drawer(
        child: AppSettings(onSettingsUpdate: refresh),
      ),
    );
  }

  void handleGetReadyEnded() {
    var workoutTimerWidget = workoutTimerKey.currentWidget as Timer;
    workoutTimerWidget.start();
    Vibration.vibrate();
    playNotification();
  }

  void handleWorkoutEnded() {
    var restTimerWidget = restTimerKey.currentWidget as Timer;
    restTimerWidget.start();
    Vibration.vibrate();
    playNotification();
  }

  void handleRestEnded() {
    var getReadyTimerWidget = getReadyTimerKey.currentWidget as Timer;
    getReadyTimerWidget.reset();

    var workoutTimerWidget = workoutTimerKey.currentWidget as Timer;
    workoutTimerWidget.reset();

    var restTimerWidget = restTimerKey.currentWidget as Timer;
    restTimerWidget.reset();

    Vibration.vibrate(pattern: [500, 500, 500, 500]);
    playNotification();
    showSnackBar();
  }

  void playNotification() {
    if (playNotificationSound) {
      FlutterRingtonePlayer.playNotification();
    }
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Well done!", style: TextStyle(color: Colors.white, fontSize: 24), textAlign: TextAlign.center),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
