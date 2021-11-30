import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_stopwatch/models/workout.dart';
import 'package:workout_stopwatch/service_locator.dart';
import 'package:workout_stopwatch/services/workout_service.dart';
import 'package:workout_stopwatch/widgets/workout_create_screen.dart';
import 'package:workout_stopwatch/widgets/workout_screen.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workouts",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WorkoutListPage(),
    );
  }
}

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({Key? key}) : super(key: key);

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  WorkoutService workoutService = getIt<WorkoutService>();
  late List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    workoutService.list().then((value) {
      setState(() {
        workouts = value;
      });
    });
  }

  void addWorkout(Workout workout) {
    setState(() {
      workoutService.create(workout);
      workouts.add(workout);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workouts"),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: workouts.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[400],
            child: ListTile(
              title: Text(workouts[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkoutScreen(workout: workouts[index])),
                );
              }, // Handle your onTap here.
            ),
          );
        }, separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WorkoutCreateScreen(addWorkout: addWorkout)),
          );
        },
        tooltip: 'Create workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}
