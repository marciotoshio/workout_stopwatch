import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

void main() {
  runApp(const WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  const WorkoutTimer({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Stopwatch',
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
      home: const MyHomePage(
        title: 'Workout Stopwatch',
        times: {'GetReady': 3, 'Workout': 5, 'Rest': 2}
      ),
    );
  }
}

class Timer extends StatelessWidget {
  final StopWatchTimer timer;
  final int time;
  final MaterialColor color;

  Timer({Key? key, required this.timer, required this.time, required this.color}) : super(key: key) {
    timer.setPresetSecondTime(time);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: time,
      child: Container(
        color: color,
        child: Center(
          child: StreamBuilder<int>(
            stream: timer.rawTime,
            initialData: 0,
            builder: (context, snapshot) {
              final value = snapshot.data;
              final displayTime = StopWatchTimer.getDisplayTime(value!, milliSecond: false, hours: false);
              return Text(displayTime, style: Theme.of(context).textTheme.headline4);
            }
          )
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.times}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Map<String, int> times;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StopWatchTimer getReadyTimer;
  late StopWatchTimer  workoutTimer;
  late StopWatchTimer  restTimer;

  @override
  void initState() {
    super.initState();

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
            time: widget.times['GetReady'] ?? 0,
            color: Colors.lightBlue,
          ),
          Timer(
            timer: workoutTimer,
            time: widget.times['Workout'] ?? 0,
            color: Colors.blue,
          ),
          Timer(
            timer: restTimer,
            time: widget.times['Rest'] ?? 0,
            color: Colors.blueGrey,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { getReadyTimer.onExecute.add(StopWatchExecute.start); },
        tooltip: 'Start',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void handleGetReadyEnded() {
    workoutTimer.onExecute.add(StopWatchExecute.start);
  }

  void handleWorkoutEnded() {
    restTimer.onExecute.add(StopWatchExecute.start);
  }

  void handleRestEnded() {
    getReadyTimer.onExecute.add(StopWatchExecute.reset);
    workoutTimer.onExecute.add(StopWatchExecute.reset);
    restTimer.onExecute.add(StopWatchExecute.reset);
  }
}
