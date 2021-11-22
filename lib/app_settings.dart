import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

typedef RefreshCallback = void Function();

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key, required this.onSettingsUpdate}) : super(key: key);

  final RefreshCallback onSettingsUpdate;

  static const keyGetReadyTime = 'key-get-ready-time';
  static const keyWorkoutTime = 'key-workout-time';
  static const keyRestTime = 'key-rest-time';
  static const keyNotificationSound = 'key-notification-sound';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Settings'),
        ),
        SliderSettingsTile(
          title: 'Get ready time',
          settingKey: keyGetReadyTime,
          defaultValue: 5,
          min: 0,
          max: 30,
          step: 1,
          leading: const Icon(Icons.all_inclusive),
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyGetReadyTime: $value');
          },
        ),
        SliderSettingsTile(
          title: 'Workout time',
          settingKey: keyWorkoutTime,
          defaultValue: 30,
          min: 0,
          max: 180,
          step: 1,
          leading: const Icon(Icons.all_inclusive),
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyWorkoutTime: $value');
          },
        ),
        SliderSettingsTile(
          title: 'Rest time',
          settingKey: keyRestTime,
          defaultValue: 10,
          min: 0,
          max: 120,
          step: 1,
          leading: const Icon(Icons.all_inclusive),
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyRestTime: $value');
          },
        ),
        CheckboxSettingsTile(
          leading: const Icon(Icons.notifications),
          settingKey: keyNotificationSound,
          title: 'Notification sound',
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyNotificationSound: $value');
          },
        ),
      ]
    );
  }
}
