import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../notifications.dart';

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
    var context = containerKey.currentContext;
    if (context != null) {
      const AnimationResetNotification().dispatch(context);
    }
  }

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  double animatedContainerHeight = 0;
  int animationTime = 0;

  bool startAnimation(AnimationStartNotification notification) {
    setState(() {
      animatedContainerHeight = notification.containerHeight;
      animationTime = widget.time;
    });
    return true;
  }

  bool resetAnimation(AnimationResetNotification notification) {
    setState(() {
      animatedContainerHeight = 0;
      animationTime = 1;
    });
    return true;
  }

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  @override
  void dispose() {
    widget.timer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<AnimationStartNotification>(
      onNotification: startAnimation,
      child: NotificationListener<AnimationResetNotification>(
        onNotification: resetAnimation,
        child: Expanded(
          flex: widget.time,
          child: Container(
            key: widget.containerKey,
            color: widget.color,
            child: Stack(
              children: [
                AnimatedContainer(
                  height: animatedContainerHeight,
                  color: darken(widget.color),
                  duration: Duration(seconds: animationTime),
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
        ),
      )
    );
  }
}
