import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weathery/Functionalities/DataProviders.dart';
import 'package:weathery/Functionalities/localValues.dart';
import 'package:weathery/Screens/mainScreen.dart';
import 'package:weathery/Functionalities/notifications.dart';
import 'package:weathery/themeData.dart';
import '../semiWidgets.dart';
import '../main.dart';
import 'package:app_settings/app_settings.dart';
import 'package:http/http.dart' as http;

import 'homeWidgetControl.dart';

var providerCon = ProviderContainer();

Future<void> getCurrentLocation({defaultCallCheck = false}) async {
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
          "Location access is required in order to get precise weather details, As you selected \"Never\", You need to enable permission in Settings manually."),
      actions: [
        ElevatedButton(
          onPressed: () {
            AppSettings.openAppSettings(asAnotherTask: true);
          },
          child: const Text("Open Settings"),
        ),

          ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Quit"))

      ],
    );
  } else if (permission != LocationPermission.always) {
    alertUserAsync(
      title: const Text("Location And Alarm Access Required"),
      content: Text(
        "Location access is required in order to get precise weather details.\nPlease Select Allow Always For Location and Allow Alarm And Reminder Settings So That Location Can Be Used In Background To Update The Widget!",
        style: captionStyle.copyWith(fontSize: 18),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            await Geolocator.requestPermission();
            permission = await Geolocator.checkPermission();
            if (permission != LocationPermission.always) {

              Navigator.of(globalNavigatorKey.currentContext!,
                      rootNavigator: true)
                  .pop();
              await Permission.locationAlways.request();
              await Permission.scheduleExactAlarm.request();
              Position position = await Geolocator.getCurrentPosition(
                  locationSettings:
                      AndroidSettings(accuracy: LocationAccuracy.medium));
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
            Navigator.of(globalNavigatorKey.currentContext!,
                    rootNavigator: true)
                .pop();
          },
          child: const Text("Ignore :("),
        ),
      ],
    );
  }

  else {
   if (!(await Permission.scheduleExactAlarm.isGranted)){
     alertUserAsync(
       title: const Text(
           "Schedule Exact Alarm Required For Notifications and Widget"),
       content: Text(
         "Schedule Exact Alarm Setting is required in order to get precise weather details in background to update widget and send update notifications!",
         style: captionStyle.copyWith(fontSize: 18),
       ),
       actions: [
         ElevatedButton(
           onPressed: () async {
             await Permission.scheduleExactAlarm.request();
             if (await Permission.scheduleExactAlarm.isGranted) {
               Navigator.of(globalNavigatorKey.currentContext!,
                   rootNavigator: true)
                   .pop();
             }
             FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
             FlutterLocalNotificationsPlugin();
             flutterLocalNotificationsPlugin
                 .resolvePlatformSpecificImplementation<
                 AndroidFlutterLocalNotificationsPlugin>()
                 ?.requestNotificationsPermission();

             Position position = await Geolocator.getCurrentPosition(
                 locationSettings: AndroidSettings(accuracy: LocationAccuracy.medium));

             double lat = position.latitude;
             double long = position.longitude;

             var locationObj = Location();
             await locationObj.initPrefObj();
             locationObj.setLoaction(lat, long);
             getWeather(lat: lat, long: long, defaultCall: defaultCallCheck);
           },
           child: const Text("Allow"),
         ),
         ElevatedButton(
           onPressed: () async{
             Navigator.of(globalNavigatorKey.currentContext!,
                 rootNavigator: true)
                 .pop();
             FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
             FlutterLocalNotificationsPlugin();
             flutterLocalNotificationsPlugin
                 .resolvePlatformSpecificImplementation<
                 AndroidFlutterLocalNotificationsPlugin>()
                 ?.requestNotificationsPermission();

             Position position = await Geolocator.getCurrentPosition(
                 locationSettings: AndroidSettings(accuracy: LocationAccuracy.medium));

             double lat = position.latitude;
             double long = position.longitude;

             var locationObj = Location();
             await locationObj.initPrefObj();
             locationObj.setLoaction(lat, long);
             getWeather(lat: lat, long: long, defaultCall: defaultCallCheck);
           },
           child: const Text("Ignore :("),
         ),
       ],
     );

   }
  else{
     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
     FlutterLocalNotificationsPlugin();
     flutterLocalNotificationsPlugin
         .resolvePlatformSpecificImplementation<
         AndroidFlutterLocalNotificationsPlugin>()
         ?.requestNotificationsPermission();

     Position position = await Geolocator.getCurrentPosition(
         locationSettings: AndroidSettings(accuracy: LocationAccuracy.medium));

     double lat = position.latitude;
     double long = position.longitude;

     var locationObj = Location();
     await locationObj.initPrefObj();
     locationObj.setLoaction(lat, long);
     getWeather(lat: lat, long: long, defaultCall: defaultCallCheck);
   }
  }
}

getWeather({lat, long, defaultCall = false}) async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
    return;
  }
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=<API_KEY>&q=$lat,$long&aqi=yes&alerts=yes&days=2');
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

  if (defaultCall) {
    setData(body, true);

    updateWidgetData(
        body["current"]["condition"]["icon"].toString().substring(21),
        body["current"]["temp_c"]!.round(),
        body["current"]["condition"]["text"],
        body['location']["name"],
        body["current"]['precip_mm'] > 0,
        body['current']['air_quality']['us-epa-index'] > 2,
        body['alerts']['alert'].length > 0);
  } else {
    setData(body, false);
  }
}

void setData(var body, bool notFirstTime) async {
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
    case 6:
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
      changeFirstTime: !notFirstTime,
      iconPathWithoutAPI:
          body["current"]["condition"]["icon"].toString().substring(21));

  if (providerCon.read(favLocationProvider).prefObj == null) {
    providerCon.read(favLocationProvider).prefObj =
        await providerCon.read(favLocationProvider).initPrefObj();
  }
  BuildContext? context = globalNavigatorKey.currentContext;
  GoRouter.of(context!).pushReplacement("/main", extra: DateTime.timestamp());
}

void getWeatherFromName({city}) async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
  }
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=<API_KEY>&q=$city&aqi=yes&alerts=yes&days=2');
  var response;
  try {
    response = await http.get(url);
  } on SocketException {
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
  setData(body, false);
}

Future<dynamic> searchlocationNames({str}) async {
  bool result = await InternetConnectionChecker.instance.hasConnection;
  if (result == false) {
    showInternetConnectionWarning();
    return;
  }

  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/search.json?key=<API_KEY>&q=$str');
  var response;
  try {
    response = await http.get(url);
  } on SocketException  {
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
  Output Format : Array<temp desc,info of rain or snow, current condition, icon, no. of alerts, city, temp>
   */
  WidgetsFlutterBinding.ensureInitialized();
  var out = [];
  String positionCord;
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.always) {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.medium,
          // Recommended: Add a timeLimit for AndroidSettings
          timeLimit: const Duration(seconds: 15), // Adjust this value as needed
        ),
      ).timeout(
        const Duration(seconds: 20), // Overall timeout for the Future
        onTimeout: () {
          // This callback is executed if the timeout occurs

          throw Exception(
              'Location acquisition timed out'); // Re-throw to enter catch block
        },
      );
      positionCord = "${position.latitude},${position.longitude}";
    } catch (_) {

      try {
        Position? position = await Geolocator.getLastKnownPosition().timeout(
          const Duration(seconds: 20), // Overall timeout for the Future
          onTimeout: () {
            throw Exception("LAST KNOW EEOE");
          },
        );
        positionCord = "${position!.latitude},${position.longitude}";
      } catch (_) {
        var locObj = Location();
        await locObj.initPrefObj();
        positionCord = locObj.getLastKnowLocation();
      }
    }
  } else {

    var locObj = Location();
    await locObj.initPrefObj();
    positionCord = locObj.getLastKnowLocation();
  }
  Map<String, dynamic> body = {};
  Uri url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=<API_KEY>&q=$positionCord&aqi=yes&alerts=yes&days=1');
  var response;
  try {
    response = await http.get(url);
  } on SocketException catch (e) {
    return [];
  }
  try {
    body = jsonDecode(response.body);
  } on FormatException  {
    return [];
  }
  out.add(analyzeTemperature(body));
  out.add(analyzeWeather(body));
  out.add(body["current"]["condition"]["text"]);
  out.add(body["current"]["condition"]["icon"].toString().substring(21));
  out.add(body['alerts']['alert'].length);
  out.add(body['location']["name"]);
  out.add(body['current']['air_quality']['us-epa-index'] > 2);
  out.add(body["current"]["temp_c"]);

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
    UpdateWidgetBackground(passedWeatherInfo: weatherInfo);
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
    UpdateWidgetBackground(passedWeatherInfo: weatherInfo);
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

    UpdateWidgetBackground(passedWeatherInfo: weatherInfo);
  }
}

@pragma('vm:entry-point')
Future UpdateWidgetBackground({passedWeatherInfo}) async {
  List weatherInfo = passedWeatherInfo ?? await BackGroundWeather();
  /*
  Output Format : Array<0 temp desc,1 info of rain or snow,2 current condition,3 icon,
  4 no. of alerts,5  city, 6 aqi ,7 temp>
   */
  updateWidgetData(
      weatherInfo[3],
      weatherInfo[7]!.round(),
      weatherInfo[2],
      weatherInfo[5],
      !(weatherInfo[1].isEmpty),
      weatherInfo[6],
      weatherInfo[4] > 0);

}
