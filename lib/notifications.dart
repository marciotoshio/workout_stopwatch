import 'package:flutter/cupertino.dart';

class AnimationStartNotification extends Notification {
  final double containerHeight;

  const AnimationStartNotification({required this.containerHeight});
}

class AnimationResetNotification extends Notification {
  const AnimationResetNotification();
}
