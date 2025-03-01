import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:weathery/localValues.dart';
import 'package:weathery/mainScreen.dart';
import 'package:weathery/notifications.dart';
import 'package:weathery/themeData.dart';
import 'semiWidgets.dart';
import 'main.dart';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;

BuildContext? context = globalNavigatorKey.currentContext;

Future<void> getCurrentLocation() async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
    return;
  }
  LocationPermission permission;
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    alertUser(
      title: const Text("Location Access Required"),
      content: const Text(
          "Location access is required in order to get precise weather details. As you selected \"Never\", You need to enable permission in Settings manually."),
      actions: [
        ElevatedButton(
          onPressed: () {
            AppSettings.openAppSettings(asAnotherTask: true);
          },
          child: const Text("Open Settings"),
        ),
      ],
    );
  } else if (permission == LocationPermission.unableToDetermine ||
      permission == LocationPermission.denied) {
    alertUserAsync(
      title: const Text("Location Access Required"),
      content: const Text(
          "Location access is required in order to get precise weather details."),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await Geolocator.requestPermission();
            permission = await Geolocator.checkPermission();
            if (permission == LocationPermission.always ||
                permission == LocationPermission.whileInUse) {
              Navigator.of(globalNavigatorKey.currentContext!,
                      rootNavigator: true)
                  .pop();
              Position position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.medium);
              double lat = position.latitude;
              double long = position.longitude;

              FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
                  FlutterLocalNotificationsPlugin();
              flutterLocalNotificationsPlugin
                  .resolvePlatformSpecificImplementation<
                      AndroidFlutterLocalNotificationsPlugin>()
                  ?.requestNotificationsPermission();

              var locationObj = Location();
              await locationObj.initPrefObj();
              locationObj.setLoaction(lat, long);
              getWeather(lat: lat, long: long);
            }
          },
          child: const Text("Allow"),
        ),
        ElevatedButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: const Text("Exit"),
        ),
      ],
    );
  } else {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double lat = position.latitude;
    double long = position.longitude;

    var locationObj = Location();
    await locationObj.initPrefObj();
    locationObj.setLoaction(lat, long);
    getWeather(lat: lat, long: long);
  }
}

getWeather({lat, long}) async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
    return;
  }
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=f860852440924b7485990349231704&q=$lat,$long&aqi=yes&alerts=yes&days=2');
  var response;
  try {
    response = await http.get(url);
  } on SocketException {
    showInternetConnectionWarning();
    return;
  }
  try {
    body = jsonDecode(response.body);
  } on FormatException {
    alertUser(
      title: const Center(child: Text("Service Unavailable")),
      content: const Text(
          "WeatherAPI is currently facing issues.\nPlease try after some time"),
      actions: [
        ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text("Quit"))
      ],
    );
  }
  setData(body);
}

void setData(var body) {
  alerts.clear();
  setLocationData(
    city: body['location']["name"],
    state: body['location']["region"],
    country: body['location']["country"],
    isday: body["current"]["is_day"],
  );
  posLat = body['location']["lat"].toString();
  posLong = body['location']["lon"].toString();

  var rainvalue = body["current"]['precip_mm'];
  var descOfRain;
  if (rainvalue == 0) {
    descOfRain = "No Rain\n\nUmbrella? What's that ?";
  } else if (0 < rainvalue && rainvalue < 0.25) {
    descOfRain = "Is It Even Raining?\n\nGo Enjoy These Showers";
  } else if (rainvalue < 2.5) {
    descOfRain = "Light Showers\n\nCan go outside without Umbrella";
  } else if (rainvalue < 7.5) {
    descOfRain = "Moderate Rain\n\nTake Your Umbrella With You";
  } else if (rainvalue < 35.5) {
    descOfRain = "Heavy Rain\n\nTake Your Umbrella With You";
  } else {
    descOfRain = "Extreme Condition\n\nStay Indoors";
  }
  switch (body['current']['air_quality']['us-epa-index']) {
    case 1:
      setAQI(usepa: "1", desc: "Good");
      break;
    case 2:
      setAQI(usepa: "2", desc: "Moderate");
      break;
    case 3:
      setAQI(usepa: "3", desc: "Unhealthy For Sensitive Group");
      break;
    case 4:
      setAQI(usepa: "4", desc: "Unhealthy");
      break;
    case 5:
      setAQI(usepa: "5", desc: "Very Unhealthy");
      break;
    case 5:
      setAQI(usepa: "6", desc: "Hazardous");
      break;
  }
  setAlerts(body['alerts']['alert']);
  setForecast(body['forecast']['forecastday']);
  setRainInfo(measure: rainvalue, desc: descOfRain);
  setWeatherData(
      rainData: analyzeWeather(body),
      temp: body["current"]["temp_c"].toString(),
      desc: body["current"]["condition"]["text"],
      feels: body["current"]["feelslike_c"].toString(),
      pressure: body["current"]["pressure_mb"].toString(),
      iconPathWithoutAPI:
          body["current"]["condition"]["icon"].toString().substring(21));
  Navigator.pushReplacementNamed(context!, "/main");
}

void getWeatherFromName({city}) async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
    return;
  }
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=f860852440924b7485990349231704&q=$city&aqi=yes&alerts=yes&days=2');
  var response;
  try {
    response = await http.get(url);
  } on SocketException catch (e) {
    showInternetConnectionWarning();
    return;
  }
  try {
    body = jsonDecode(response.body);
  } catch (e) {
    if (e == FormatException) {
      alertUser(
        title: const Center(child: Text("Service Unavailable")),
        content: const Text(
            "WeatherAPI is currently facing issues.\nPlease try after some time"),
        actions: [
          ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Quit"))
        ],
      );
    }
  }
  setData(body);
}

Future<dynamic> searchlocationNames({str}) async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
    return;
  }
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/search.json?key=f860852440924b7485990349231704&q=$str');
  var response;
  try {
    response = await http.get(url);
  } on SocketException catch (e) {
    showInternetConnectionWarning();
    return;
  }
  return json.decode(response.body).cast<Map<String, dynamic>>();
}

setAlerts(List<dynamic> alertList) {
  if (alertList.length == 0) {
    alerts.add(
      Text(
        "No Alerts In This Area",
        style: headingStyle.copyWith(fontSize: 20),
      ),
    );
  } else {
    for (int i = 0; i < alertList.length; i++) {
      var alert = alertList[i];
      String bodyTXT = alert["headline"];
      try {
        bodyTXT += ".\nIn" +
            alert["desc"]
                .split('*')[2]
                .replaceAll('WHERE', "")
                .replaceAll("\n", '');
      } on RangeError {
        bodyTXT += "";
      }
      try {
        bodyTXT += alert["desc"]
            .split('*')[4]
            .replaceAll('IMPACTS', "")
            .replaceAll("\n", '');
      } on RangeError {
        bodyTXT += "";
      }
      alerts.add(WeatherAlertDisplayObject(
          alert, bodyTXT.replaceAll("...", '').trim()));
    }
  }
}

setForecast(List<dynamic> forecastList) {
  forecastsWidgetList.clear();
  int currentHour = DateTime.now().hour;
  List mainData = forecastList[0]["hour"];
  mainData.addAll(forecastList[1]["hour"]);
  for (int i = currentHour + 1; i <= currentHour + 24; i++) {
    forecastsWidgetList.add(ForecastDisplayObject(mainData[i]));
    forecastsWidgetList.add(
      VerticalDivider(
        thickness: 1,
        color: secondaryTextColor,
        indent: 20,
        endIndent: 20,
      ),
    );
  }
  forecastsWidgetList.removeLast();
}

@pragma('vm:entry-point')
Future<List> BackGroundWeather() async {
  /*
  Output Format : Array<temp,info of rain or snow, current condition, icon, no. of alerts>
   */
  var out = [];
  var locObj = Location();
  await locObj.initPrefObj();
  var positionCord = locObj.getLastKnowLocation();
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=f860852440924b7485990349231704&q=$positionCord&alerts=yes&days=1');
  var response;
  try {
    response = await http.get(url);
  } on SocketException catch (e) {
    return [];
  }
  try {
    body = jsonDecode(response.body);
  } on FormatException catch (e) {
    return [];
  }
  out.add(analyzeTemperature(body));
  out.add(analyzeWeather(body));
  out.add(body["current"]["condition"]["text"]);
  out.add(body["current"]["condition"]["icon"].toString().substring(21));
  out.add(body['alerts']['alert'].length);
  return out;
}

@pragma('vm:entry-point')
Future<void> MorningMessage() async {
  var obj = NotificationSettings();
  await obj.initPrefObj();
  if (obj.getMorningSavedStatus()) {
    List weatherInfo =
        await BackGroundWeather(); //temp,rain or snow, desc,icon,no. of alerts
    var message = await getMorningNotificationValues();
    String dispMessage = message[1] +
        ((weatherInfo[1].isEmpty) ? "" : '\n${weatherInfo[1]}') +
        "\nTemprature : ${weatherInfo[0]}\nCurrent Condition : ${weatherInfo[2]}\nActive Alerts : ${weatherInfo[4]} Alerts";
    NotificationManger()
        .showMorningNotification(message[0], dispMessage, weatherInfo[3]);
  }
}

@pragma('vm:entry-point')
Future NoonMessage() async {
  var obj = NotificationSettings();
  await obj.initPrefObj();
  if (obj.getNoonSavedStatus()) {
    List weatherInfo =
        await BackGroundWeather(); //temp,rain or snow, desc,icon,no. of alerts
    var message = await getNoonNotificationValues();
    String dispMessage = message[1] +
        ((weatherInfo[1].isEmpty) ? "" : '\n${weatherInfo[1]}') +
        "\nTemprature : ${weatherInfo[0]}\nCurrent Condition : ${weatherInfo[2]}\nActive Alerts : ${weatherInfo[4]} Alerts";
    NotificationManger()
        .showNoonNotification(message[0], dispMessage, weatherInfo[3]);
  }
}

@pragma('vm:entry-point')
Future NightMessage() async {
  var obj = NotificationSettings();
  await obj.initPrefObj();

  if (obj.getNightSavedStatus()) {
    List weatherInfo =
        await BackGroundWeather(); //temp,rain or snow, desc,icon,no. of alerts
    var message = await getNightNotificationValues();
    String dispMessage = message[1] +
        ((weatherInfo[1].isEmpty) ? "" : '\n${weatherInfo[1]}') +
        "\nTemprature : ${weatherInfo[0]}\nCurrent Condition : ${weatherInfo[2]}\nActive Alerts : ${weatherInfo[4]} Alerts";
    NotificationManger()
        .showNightNotification(message[0], dispMessage, weatherInfo[3]);
  }
}
