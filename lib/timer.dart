import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'animation_start_notification.dart';

class Timer extends StatefulWidget {
  final StopWatchTimer timer;
  final int time;
  final MaterialColor color;
  final GlobalKey containerKey = GlobalKey();

  Timer({Key? key, required this.timer, required this.time, required this.color}) : super(key: key) {
    timer.clearPresetTime();
    timer.setPresetSecondTime(time);
  }

  void dispose() {
    timer.dispose();
  }

  void start() {
    timer.onExecute.add(StopWatchExecute.start);

    var context = containerKey.currentContext;
    if (context != null) {
      var renderBoxRed = context.findRenderObject() as RenderBox;
      AnimationStartNotification(containerHeight: renderBoxRed.size.height).dispatch(context);
    }
  }

  void reset() {
    timer.onExecute.add(StopWatchExecute.reset);
  }

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  double animatedContainerHeight = 0;

  bool startAnimation(AnimationStartNotification notification) {
    setState(() {
      animatedContainerHeight = notification.containerHeight;
    });
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    return NotificationListener<AnimationStartNotification>(
      onNotification: startAnimation,
      child: Expanded(
        flex: widget.time,
        child: Container(
          key: widget.containerKey,
          color: widget.color,
          child: Stack(
            children: [
              AnimatedContainer(
                height: animatedContainerHeight,
                color: Colors.yellow,
                duration: Duration(seconds: widget.time),
              ),
              Align(
                alignment: Alignment.center,
                child: StreamBuilder<int>(
                  stream: widget.timer.rawTime,
                  initialData: 0,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    final displayTime = StopWatchTimer.getDisplayTime(
                        value!, milliSecond: false, hours: false);
                    return Text(displayTime, style: Theme
                        .of(context)
                        .textTheme
                        .headline4);
                  }
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
