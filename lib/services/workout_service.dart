import 'package:workout_stopwatch/workout_database.dart';
import 'package:workout_stopwatch/models/workout.dart';

abstract class WorkoutService {
  Future<Workout> create(Workout workout);
  Future<List<Workout>> list();
}

class MemoryWorkoutService extends WorkoutService {
  List<Workout> workouts = [];

  @override
  Future<Workout> create(Workout workout) async {
    workouts.add(workout);
    return workout;
  }

  @override
  Future<List<Workout>> list() async {
    return workouts;
  }
}

class SqlWorkoutService extends WorkoutService {

  @override
  Future<Workout> create(Workout workout) async {
    final db = await WorkoutDatabase.instance.database;
    await db.insert("workouts", workout.toMap());

    return workout;
  }

  @override
  Future<List<Workout>> list() async {
    final db = await WorkoutDatabase.instance.database;

    final result = await db.query("workouts");
    return result.map((w) => Workout.fromMap(w)).toList();
  }
}

