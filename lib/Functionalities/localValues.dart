import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> heads = [
  "Good ",
  "",
  "Lazy ",
  "Cheerful ",
  "Amazing ",
  "Sleepy ",
  "Cozy "
];
List<String> morningMessages = [
  "Going Outside ?",
  "Ready To Conquer The Day?",
  '',
  "Going For a Morning Walk ?",
  "Ready For a Great Day ?",
  "Going For Work ?"
];
List<String> noonMessages = [
  "Ready To Tackle The Afternoon?",
  "Going Outside For a Lunch ?",
  'Going Outside ?',
  "Tired on Work ?",
  "Going For a Brunch ?",
  "Ready for a Power Nap ?"
];
List<String> nightMessages = [
  "Going For a Dinner ?",
  '',
  "Going For a Candle Light Dinner ?",
  "Going For a Nightout ?",
  'Going For a Party ?',
  "Preparing For a Party ?",
  "Planning a Nightout ?",
  'Going To a Club ?'
];

List<String> shareMessages = [
  "Take A Look At The Weather Of %USERCITY, %USERCOUNTRY\nCheck Here : https://aryanshdev.github.io/weathery/%LAT/%LONG",
  "Check Out The Current Weather In %USERCITY, %USERCOUNTRY!\nPowered By Weathery @ https://play.google.com/store/apps/details?id=com.CPLLabs.weathery",
  "Current Weather Conditions Of %USERCITY, %USERCOUNTRY\nCheck Here : https://aryanshdev.github.io/weathery/%LAT/%LONG",
  "Current Weather At %USERCITY, %USERCOUNTRY\nCheck Here : https://aryanshdev.github.io/weathery/%LAT/%LONG",
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

class FavouriteLocations {
  var prefObj;

  Future<dynamic> initPrefObj() async {
    WidgetsFlutterBinding.ensureInitialized();
    prefObj = await SharedPreferences.getInstance();
    return prefObj;
  }

  void setLoaction(
      int slot, String lat, long, placeName, stateName, countryName) {
    _saveFavLocation(slot, "$placeName,$stateName,$countryName,$lat,$long");
  }

  void deleteFavLocation(int locNum) {
    _deleteFavLocation(locNum);
  }

  void _deleteFavLocation(int locNum) async {
    await prefObj.remove('favLocation$locNum');
  }

  void _saveFavLocation(int locNum, String combinedString) async {
    await prefObj.setString('favLocation$locNum', combinedString);
  }

  dynamic getFavLocation(int locNum) {
    return prefObj.getString('favLocation$locNum');
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

String analyzeWeather(Map<String, dynamic> body) {
  String out = "";
  List<List<int>> multiPurposeDescVar = [[], []];
  int currentHour = DateTime.now().hour;
  for (int i = currentHour; i <= currentHour + 6; i++) {
    multiPurposeDescVar[0]
        .add(body["forecast"]['forecastday'][0]["hour"][i]["will_it_rain"]);
    multiPurposeDescVar[1]
        .add(body["forecast"]['forecastday'][0]["hour"][i]["will_it_snow"]);
  }
  bool multi = false;
  if (multiPurposeDescVar[0].contains(1)) {
    out = "Possibilities of Rain";
    multi = true;
  }
  if (multiPurposeDescVar[1].contains(1)) {
    out += (multi) ? ", Snowfall" : "Possibilities of Snowfall";
    multi = true;
  }
  return out;
}

String analyzeTemperature(Map<String, dynamic> body) {
  List<double> multiPurposeDescVar = [];
  int currentHour = DateTime.now().hour;
  for (int i = currentHour; i <= currentHour + 6; i++) {
    multiPurposeDescVar
        .add(body["forecast"]['forecastday'][0]["hour"][i]["temp_c"]);
  }
  return "Ranging From ${multiPurposeDescVar.reduce(min)}°C To ${multiPurposeDescVar.reduce(max)}°C";
}

String getShareMessage(city, country, lat, long) {
  return shareMessages[Random().nextInt(shareMessages.length)]
      .replaceAll("%USERCITY", city)
      .replaceAll("%USERCOUNTRY", country)
      .replaceAll("%LAT", lat)
      .replaceAll("%LONG", long);
}
