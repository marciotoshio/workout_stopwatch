class Workout {
  final int id;
  final String name;
  final int getReadyTime;
  final int workoutTime;
  final int restTime;

  Workout(this.id, this.name, this.getReadyTime, this.workoutTime, this.restTime);

  factory Workout.fromMap(Map<String, dynamic> data) => Workout(
      data["id"],
      data["name"],
      data["getReadyTime"],
      data["workoutTime"],
      data["restTime"]
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "getReadyTime": getReadyTime,
    "workoutTime": workoutTime,
    "restTime": restTime
  };
}
