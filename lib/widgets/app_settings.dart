import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

typedef RefreshCallback = void Function();

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key, required this.onSettingsUpdate}) : super(key: key);

  final RefreshCallback onSettingsUpdate;

  static const keyNotificationSound = 'key-notification-sound';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Settings'),
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
