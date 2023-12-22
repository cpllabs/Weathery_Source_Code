import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:weathery/about.dart';
import 'package:weathery/apiData.dart';
import 'package:weathery/mainScreen.dart';
import 'package:weathery/settings.dart';
import 'themeData.dart';
import 'package:flutter/material.dart';
import 'localValues.dart';
import 'firstStartupPage.dart';
import 'NormalStartupPage.dart';

var userName = UserName();
final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  await AndroidAlarmManager.cancel(0);
  await AndroidAlarmManager.cancel(1);
  await AndroidAlarmManager.cancel(2);

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    0,
    MorningAlertFunction,
    allowWhileIdle: true,
    startAt:
        calculateDurationFromSpecificTime(
            const TimeOfDay(hour: 6, minute: 30)),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    1,
    NoonAlertFunction,
    allowWhileIdle: true,
    startAt: calculateDurationFromSpecificTime(
        const TimeOfDay(hour: 12, minute: 30)),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    2,
    NightAlertFunction,
    allowWhileIdle: true,
    startAt: calculateDurationFromSpecificTime(
        const TimeOfDay(hour: 20, minute: 00)),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );
  String route = '';
  await userName.initPrefObj();
  if (userName.getName() == null) {
    route = "/first";
  } else {
    route = "/normal";
  }

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MainApp(firstRoute: route));
}

class MainApp extends StatelessWidget {
  String initRoute = "";
  MainApp({Key? key, firstRoute}) : super(key: key) {
    initRoute = firstRoute;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      navigatorKey: globalNavigatorKey,
      initialRoute: initRoute,
      routes: {
        "/first": (context) => firstStartUp(
              usernameObj: userName,
            ),
        '/normal': (context) => NormalStartUp(),
        "/main": (context) => MainScreen(
              userNameObj: userName,
            ),
        "/about": (context) => const AboutPage(),
        "/settings": (context) => const SettingsPage(),
      },
    );
  }
}

@pragma('vm:entry-point')
calculateDurationFromSpecificTime(TimeOfDay specificTime) {
  final now = DateTime.now();
  var targetTime = DateTime(
      now.year, now.month, now.day, specificTime.hour, specificTime.minute);
  if (targetTime.isBefore(now)) {
    targetTime = targetTime.add(const Duration(days: 1));
  }
  return targetTime;
}

@pragma('vm:entry-point')
void MorningAlertFunction() {
  MorningMessage();
}

@pragma('vm:entry-point')
void NoonAlertFunction() {
  NoonMessage();
}

@pragma('vm:entry-point')
void NightAlertFunction() {
  NightMessage();
}
