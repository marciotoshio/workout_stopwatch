import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_stopwatch/models/workout.dart';

class WorkoutCreateScreen extends StatelessWidget {
  final Function addWorkout;
  const WorkoutCreateScreen({Key? key, required this.addWorkout}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Create workout",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutCreatePage(addWorkout: addWorkout),
    );
  }
}

class WorkoutCreatePage extends StatefulWidget {
  final Function addWorkout;
  const WorkoutCreatePage({Key? key, required this.addWorkout}) : super(key: key);

  @override
  State<WorkoutCreatePage> createState() => _WorkoutCreatePageState();
}

class _WorkoutCreatePageState extends State<WorkoutCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final workoutNameController = TextEditingController();
  final getReadyTimeController = TextEditingController();
  final workoutTimeController = TextEditingController();
  final restTimeController = TextEditingController();

  @override
  void dispose() {
    workoutNameController.dispose();
    getReadyTimeController.dispose();
    workoutTimeController.dispose();
    restTimeController.dispose();
    super.dispose();
  }

  void saveWorkout() {
    if (_formKey.currentState!.validate()) {
      var workout = Workout(
          null,
          workoutNameController.text,
          int.parse(getReadyTimeController.text),
          int.parse(workoutTimeController.text),
          int.parse(restTimeController.text)
      );

      widget.addWorkout(workout);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${workout.name} saved.')),
      );

      workoutNameController.text = '';
      getReadyTimeController.text = '';
      workoutTimeController.text = '';
      restTimeController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create workout"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: saveWorkout,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: TextFormField(
                controller: workoutNameController,
                decoration: const InputDecoration(hintText: "Workout name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter workout name.';
                  }
                  return null;
                },
              )
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: TextFormField(
                controller: getReadyTimeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Get ready time"),
              )
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: TextFormField(
                controller: workoutTimeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Workout time"),
              )
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: TextFormField(
                controller: restTimeController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(hintText: "Rest time"),
              )
            ),
          ],
        ),
      ),
    );
  }
}
