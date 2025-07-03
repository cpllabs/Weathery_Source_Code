import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weathery/Functionalities/DataProviders.dart';
import 'package:weathery/Screens/AboutWidgetScreen.dart';
import 'package:weathery/Screens/aboutScreen.dart';
import 'package:weathery/Functionalities/apiData.dart';
import 'package:weathery/Screens/mainScreen.dart';
import 'package:weathery/Screens/settingsScreen.dart';
import 'themeData.dart';
import 'package:flutter/material.dart';
import 'Functionalities/localValues.dart';
import 'Screens/firstStartupPage.dart';
import 'Screens/NormalStartupPage.dart';

Page<void> _fadeTransition(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

var userName = UserName();
var favPost = FavouriteLocations();
final globalNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  try {
    await _cancelExistingAlarms();
    await _scheduleAlarms();
  }on
  Exception {

  }

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );

  MobileAds.instance.initialize();
  await userName.initPrefObj();
  await favPost.initPrefObj();
  runApp(
    ProviderScope(
      overrides: [
        userNameProvider.overrideWithValue(userName),
        favLocationProvider.overrideWithValue(favPost)
      ],
      child: MainApp(
        router: GoRouter(
          navigatorKey: globalNavigatorKey,
          initialLocation: (userName.getName() == null) ? "/first" : "/normal",
          routes: [
            GoRoute(
              path: '/first',
              pageBuilder: (context, state) => _fadeTransition(
                context,
                state,
                firstStartUp(),
              ),
            ),
            GoRoute(
              path: '/normal',
              pageBuilder: (context, state) => _fadeTransition(
                context,
                state,
                NormalStartUp(),
              ),
            ),
            GoRoute(
              path: '/main',
              pageBuilder: (context, state) => _fadeTransition(
                context,
                state,
                MainScreen(),
              ),
            ),
            GoRoute(
              path: '/widgetinfo',
              pageBuilder: (context, state) => _fadeTransition(
                context,
                state,
                AboutWidgetScreen(),
              ),
            ),
            GoRoute(
              path: '/about',
              pageBuilder: (context, state) => _fadeTransition(
                context,
                state,
                const AboutPage(),
              ),
            ),
            GoRoute(
              path: '/settings',
              pageBuilder: (context, state) => _fadeTransition(
                context,
                state,
                const SettingsPage(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _cancelExistingAlarms() async {
  await AndroidAlarmManager.cancel(0);
  await AndroidAlarmManager.cancel(1);
  await AndroidAlarmManager.cancel(2);
  await AndroidAlarmManager.cancel(3);
  await AndroidAlarmManager.cancel(4);
  await AndroidAlarmManager.cancel(5);
}

Future<void> _scheduleAlarms() async {

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    0,
    MorningAlertFunction,
    allowWhileIdle: true,
    startAt: calculateDurationFromSpecificTime(
      const TimeOfDay(hour: 6, minute: 30),
    ),
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
      const TimeOfDay(hour: 12, minute: 30),
    ),
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
      const TimeOfDay(hour: 20, minute: 30),
    ),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );

  // WidgetUpdates

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    3,
    WidgetUpdate,
    allowWhileIdle: true,
    startAt: calculateDurationFromSpecificTime(
      const TimeOfDay(hour: 0, minute: 30),
    ),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );
  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    4,
    WidgetUpdate,
    allowWhileIdle: true,
    startAt: calculateDurationFromSpecificTime(
      const TimeOfDay(hour: 4, minute: 30),
    ),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );
  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    5,
    WidgetUpdate,
    allowWhileIdle: true,
    startAt: calculateDurationFromSpecificTime(
      const TimeOfDay(hour: 16, minute: 30),
    ),
    exact: true,
    rescheduleOnReboot: true,
    wakeup: true,
  );
}

class MainApp extends StatelessWidget {
  late final GoRouter router;
  MainApp({required this.router});
  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((ins) {
      List<String> list = [];
      for (int i = 1; i < 5; i++) {
        String? favData = ins.getString('favLocation$i');
        if (favData != null) {
          list.add(favData);
        }
      }
      QuickActions().setShortcutItems(
        list.asMap().entries.map((entry) {
          return ShortcutItem(
              type: entry.key.toString(),
              localizedTitle: entry.value.split(",")[0],
              icon: 'quick_action_icon');
        }).toList(),
      );
      QuickActions().initialize((clicked) {
        List<String> values = list[int.parse(clicked)].split(',');
        getWeather(
          lat: list[int.parse(clicked)].split(',')[3],
          long: list[int.parse(clicked)].split(',')[4],
        );
      });
    });

    return MaterialApp.router(
      theme: mainTheme,
      routerConfig: router,
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
  WidgetsFlutterBinding.ensureInitialized();
  MorningMessage();
}

@pragma('vm:entry-point')
void NoonAlertFunction() {
  WidgetsFlutterBinding.ensureInitialized();
  NoonMessage();
}

@pragma('vm:entry-point')
void NightAlertFunction() {
  WidgetsFlutterBinding.ensureInitialized();
  NightMessage();
}

@pragma('vm:entry-point')
void WidgetUpdate() {
  WidgetsFlutterBinding.ensureInitialized();
  UpdateWidgetBackground();
}
