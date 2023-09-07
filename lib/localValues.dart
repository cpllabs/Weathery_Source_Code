import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

var heads = ["Good ", "", "Lazy ", "Cheerful ", "Amazing "];
var morningMessages = [
  "Going Outside ?",
  '',
  "Going For a Morning Walk ?",
  "Going For Work ?"
];
var noonMessages = [
  "Going Outside For a Lunch ?",
  'Going Outside ?',
  "Tired on Work ?",
  "Going For a Brunch ?",
];
var nightMessages = [
  "Going For a Dinner ?",
  '',
  "Going For a Candle Light Dinner ?",
  "Going For a Nightout ?",
  'Going For a Party ?',
  'Going To a Club ?'
];

class Greetings {
  final int _timeHours = TimeOfDay.now().hour;
  var _message;
  Greetings() {
    if (_timeHours > 4 && _timeHours < 11) {
      _message = "${heads[Random().nextInt(heads.length)]}Morning";
    } else if (_timeHours >= 11 && _timeHours < 16) {
      _message = "${heads[Random().nextInt(heads.length)]}Noon";
    } else if (_timeHours >= 16 && _timeHours < 20) {
      _message = "${heads[Random().nextInt(heads.length)]}Evening";
    } else {
      _message = "${heads[Random().nextInt(heads.length)]}Night";
    }
  }
  String getMessage() {
    return _message;
  }
}

class UserName {
  var prefObj;

  Future initPrefObj() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefObj = await SharedPreferences.getInstance();
  }

  void setName(String inputName) {
    _saveName(inputName);
  }

  void _saveName(name) async {
    await prefObj.setString('localUserName', name);
  }

  getName() {
    return prefObj.getString('localUserName');
  }
}

class Location {
  var prefObj;

  Future initPrefObj() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefObj = await SharedPreferences.getInstance();
  }

  void setLoaction(lat, long) {
    _saveLocation("$lat,$long");
  }

  void _saveLocation(name) async {
    await prefObj.setString('lastKnownLocation', name);
  }

  @pragma('vm:entry-point')
  String getLastKnowLocation() {
    return prefObj.getString('lastKnownLocation');
  }
}

@pragma('vm:entry-point')
Future<List> getMorningNotificationValues() async {
  var userName = UserName();
  await userName.initPrefObj();
  //tilte ,body
  List<String> output = [];
  output.add(
      "${heads[Random().nextInt(heads.length)]}Morning ${userName.getName()}");
  output.add(
      "${morningMessages[Random().nextInt(morningMessages.length)]} Here's a Weather Update For Today's Morning -");
  return output;
}

@pragma('vm:entry-point')
Future<List> getNoonNotificationValues() async {
  var userName = UserName();
  await userName.initPrefObj();
  //tilte ,body
  List<String> output = [];
  output.add(
      "${heads[Random().nextInt(heads.length)]}Noon ${userName.getName()}");
  output.add(
      "${noonMessages[Random().nextInt(noonMessages.length)]} Here's a Weather Update For Today's Noon -");
  return output;
}

@pragma('vm:entry-point')
Future<List> getNightNotificationValues() async {
  var userName = UserName();
  await userName.initPrefObj();
  //tilte ,body
  List<String> output = [];
  output.add(
      "${heads[Random().nextInt(heads.length)]}Night ${userName.getName()}");
  output.add(
      "${nightMessages[Random().nextInt(nightMessages.length)]} Here's a Weather Update For Today's Night -");
  return output;
}


class NotificationSettings {
  var prefObj;
  Future initPrefObj() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefObj = await SharedPreferences.getInstance();
  }

  void setMorningStatus(bool status) {
    _saveMorningStatus(status);
  }

  void _saveMorningStatus(status) async {
    await prefObj.setBool('MorningNotifyStatus', status);
  }

  void setNoonStatus(bool status) {
    _saveNoonStatus(status);
  }

  void _saveNoonStatus(status) async {
    await prefObj.setBool('NoonNotifyStatus', status);
  }

  void setNightStatus(bool status) {
    _saveNightStatus(status);
  }

  void _saveNightStatus(status) async {
    await prefObj.setBool('NightNotifyStatus', status);
  }
  @pragma('vm:entry-point')
  getMorningSavedStatus() {
    return ((prefObj.getBool('MorningNotifyStatus') == null)
        ? true
        : prefObj.getBool('MorningNotifyStatus'));
  }
  @pragma('vm:entry-point')
  getNoonSavedStatus() {
    return ((prefObj.getBool('NoonNotifyStatus') == null)
        ? true
        : prefObj.getBool('NoonNotifyStatus'));
  }
  @pragma('vm:entry-point')
  getNightSavedStatus() {
    return ((prefObj.getBool('NightNotifyStatus') == null)
        ? true
        : prefObj.getBool('NightNotifyStatus'));
  }
}
