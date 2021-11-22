import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:vibration/vibration.dart';
import 'app_settings.dart';
import 'timer.dart';

Future main() async {
  await Settings.init(cacheProvider: SharePreferenceCache());

  runApp(const WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  const WorkoutTimer({Key? key}) : super(key: key);

  static const appTitle = 'Workout Stopwatch';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const StopWatchPage(title: appTitle),
    );
  }
}

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  late StopWatchTimer getReadyTimer;
  late StopWatchTimer  workoutTimer;
  late StopWatchTimer  restTimer;

  int getReadyTime = 5;
  int workoutTime = 30;
  int restTime = 10;

  bool playNotificationSound = false;

  @override
  void initState() {
    super.initState();

    getSettings();

    getReadyTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      onEnded: handleGetReadyEnded,
    );
    workoutTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      onEnded: handleWorkoutEnded,
    );
    restTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      onEnded: handleRestEnded,
    );
  }

  void refresh() {
    setState(getSettings);
  }

  void getSettings() {
    getReadyTime = int.parse(Settings.getValue<String>(AppSettings.keyGetReadyTime, "5"));
    workoutTime = int.parse(Settings.getValue<String>(AppSettings.keyWorkoutTime, "30"));
    restTime = int.parse(Settings.getValue<String>(AppSettings.keyRestTime, "10"));
    playNotificationSound = Settings.getValue<bool>(AppSettings.keyNotificationSound, true);
  }

  @override
  void dispose() async {
    super.dispose();
    await getReadyTimer.dispose();  // Need to call dispose function.
    await workoutTimer.dispose();
    await restTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Timer(
            timer: getReadyTimer,
            time: getReadyTime,
            color: Colors.lightBlue,
          ),
          Timer(
            timer: workoutTimer,
            time: workoutTime,
            color: Colors.blue,
          ),
          Timer(
            timer: restTimer,
            time: restTime,
            color: Colors.blueGrey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { getReadyTimer.onExecute.add(StopWatchExecute.start); },
        tooltip: 'Start',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      drawer: Drawer(
        child: AppSettings(onSettingsUpdate: refresh),
      ),
    );
  }

  void handleGetReadyEnded() {
    workoutTimer.onExecute.add(StopWatchExecute.start);
    Vibration.vibrate();
    playNotification();
  }

  void handleWorkoutEnded() {
    restTimer.onExecute.add(StopWatchExecute.start);
    Vibration.vibrate();
    playNotification();
  }

  void handleRestEnded() {
    getReadyTimer.onExecute.add(StopWatchExecute.reset);
    workoutTimer.onExecute.add(StopWatchExecute.reset);
    restTimer.onExecute.add(StopWatchExecute.reset);
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
