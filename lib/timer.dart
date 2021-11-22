import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Timer extends StatelessWidget {
  final StopWatchTimer timer;
  final int time;
  final MaterialColor color;

  Timer({Key? key, required this.timer, required this.time, required this.color}) : super(key: key) {
    timer.clearPresetTime();
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
