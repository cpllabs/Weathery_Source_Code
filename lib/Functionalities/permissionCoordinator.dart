import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weathery/themeData.dart';
import 'package:weathery/semiWidgets.dart';

/// Handles optional permissions after the user has seen the main weather screen.
class PermissionCoordinator {
  static const _keyBgLocation = 'permission_bg_location_dismissed';
  static const _keyExactAlarm = 'permission_exact_alarm_dismissed';
  static const _keyNotifications = 'permission_notifications_dismissed';
  static const _keyBattery = 'NoAdvisory';

  static bool _isRunning = false;

  static Future<void> promptDeferredPermissions(BuildContext context) async {
    if (_isRunning) return;

    final prefs = SharedPreferencesAsync();
    final needsAny = await _shouldPromptBgLocation(prefs) ||
        await _shouldPromptExactAlarm(prefs) ||
        await _shouldPromptNotifications(prefs) ||
        await _shouldPromptBattery(prefs);

    if (!needsAny) return;

    _isRunning = true;

    await Future.delayed(const Duration(seconds: 2));
    if (!context.mounted) {
      _isRunning = false;
      return;
    }

    if (await _shouldPromptBgLocation(prefs)) {
      await _promptBgLocation(context, prefs);
      if (!context.mounted) {
        _isRunning = false;
        return;
      }
    }

    if (await _shouldPromptExactAlarm(prefs)) {
      await _promptExactAlarm(context, prefs);
      if (!context.mounted) {
        _isRunning = false;
        return;
      }
    }

    if (await _shouldPromptNotifications(prefs)) {
      await _promptNotifications(context, prefs);
      if (!context.mounted) {
        _isRunning = false;
        return;
      }
    }

    if (await _shouldPromptBattery(prefs)) {
      await _promptBatteryOptimization(context, prefs);
    }

    _isRunning = false;
  }

  static Future<bool> _shouldPromptBgLocation(
      SharedPreferencesAsync prefs) async {
    if (await prefs.getBool(_keyBgLocation) == true) return false;
    final permission = await Geolocator.checkPermission();
    return permission != LocationPermission.always;
  }

  static Future<bool> _shouldPromptExactAlarm(
      SharedPreferencesAsync prefs) async {
    if (await prefs.getBool(_keyExactAlarm) == true) return false;
    return !(await Permission.scheduleExactAlarm.isGranted);
  }

  static Future<bool> _shouldPromptNotifications(
      SharedPreferencesAsync prefs) async {
    if (await prefs.getBool(_keyNotifications) == true) return false;
    return !(await Permission.notification.isGranted);
  }

  static Future<bool> _shouldPromptBattery(SharedPreferencesAsync prefs) async {
    return await prefs.getBool(_keyBattery) == null;
  }

  static Future<void> _promptBgLocation(
      BuildContext context, SharedPreferencesAsync prefs) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => PremiumDialog(
        title: const Text("Background Location"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Allow location access in the background so your home widget stays up to date.",
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await prefs.setBool(_keyBgLocation, true);
            },
            child: const Text("Not now"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Permission.locationAlways.request();
            },
            child: const Text("Allow"),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                launchUrlString('https://www.youtube.com/watch?v=oLOnlHOOxgU');
              },
              child: const Text("Know Why?"),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _promptExactAlarm(
      BuildContext context, SharedPreferencesAsync prefs) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => PremiumDialog(
        title: const Text("Alarm & Reminders"),
        content: Text(
          "Allow scheduled alarms so weather notifications and widget updates arrive on time.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await prefs.setBool(_keyExactAlarm, true);
            },
            child: const Text("Not now"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Permission.scheduleExactAlarm.request();
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  static Future<void> _promptNotifications(
      BuildContext context, SharedPreferencesAsync prefs) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => PremiumDialog(
        title: const Text("Notifications"),
        content: Text(
          "Get morning, afternoon, and evening weather updates delivered to your phone.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await prefs.setBool(_keyNotifications, true);
            },
            child: const Text("Not now"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final plugin = FlutterLocalNotificationsPlugin();
              await plugin
                  .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin>()
                  ?.requestNotificationsPermission();
            },
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }

  static Future<void> _promptBatteryOptimization(
      BuildContext context, SharedPreferencesAsync prefs) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => PremiumDialog(
        title: Text("Battery Optimization"),
        content: Text(
          "Disable battery optimization to ensure timely delivery of notifications and widget updates.",
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await prefs.setBool(_keyBattery, false);
              if (context.mounted) {
                context.go("/settings");
              }
            },
            child: const Text("Open Settings"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await prefs.setBool(_keyBattery, false);
            },
            child: const Text("Not now"),
          ),
        ],
      ),
    );
  }
}
