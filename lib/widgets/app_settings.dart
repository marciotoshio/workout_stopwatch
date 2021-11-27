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
        TextInputSettingsTile(
          title: 'Get ready time',
          settingKey: keyGetReadyTime,
          initialValue: "5",
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyGetReadyTime: $value');
          },
        ),
        TextInputSettingsTile(
          title: 'Workout time',
          settingKey: keyWorkoutTime,
          initialValue: "30",
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyWorkoutTime: $value');
          },
        ),
        TextInputSettingsTile(
          title: 'Rest time',
          settingKey: keyRestTime,
          initialValue: "10",
          onChange: (value) {
            onSettingsUpdate();
            debugPrint('$keyRestTime: $value');
          },
        ),
        SwitchSettingsTile(
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
