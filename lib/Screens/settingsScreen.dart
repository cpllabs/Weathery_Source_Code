import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weathery/Functionalities/localValues.dart';
import 'package:weathery/semiWidgets.dart';
import '../themeData.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool morningSaved = false;
  bool noonSaved = false;
  bool nightSaved = false;
  NotificationSettings carrierObj = NotificationSettings();
  UserName usernameObj = UserName();
  bool _isNativeLoaded = false;
  NativeAd? _nativeAd;
  late bool showBatteryExempt = false;

  @override
  initState() {
    super.initState();
    _init();
  }

  _init() async {
    _loadNativeAd();
    await carrierObj.initPrefObj();
    await usernameObj.initPrefObj();
    bool data =  !(await Permission.ignoreBatteryOptimizations.status.isGranted);
    print(data);
    setState(()  {
      morningSaved = carrierObj.getMorningSavedStatus();
      noonSaved = carrierObj.getNoonSavedStatus();
      nightSaved = carrierObj.getNightSavedStatus();
      showBatteryExempt = data;
    });
  }

  void _loadNativeAd() async {
    _nativeAd = NativeAd(
      nativeTemplateStyle: NativeTemplateStyle(
          primaryTextStyle: NativeTemplateTextStyle(
              textColor: Colors.white,
              style: NativeTemplateFontStyle.bold,
              size: 16.0),
          secondaryTextStyle:
              NativeTemplateTextStyle(textColor: Colors.grey, size: 12.0),
          tertiaryTextStyle:
              NativeTemplateTextStyle(textColor: Colors.grey, size: 10.0),
          templateType: TemplateType.small,
          mainBackgroundColor: primaryForegroundColor,
          cornerRadius: 10),
      adUnitId: "ca-app-pub-2238125462513134/9769120715",
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _nativeAd = ad as NativeAd;
            _isNativeLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _nativeAd = null;
          setState(() {
            _isNativeLoaded = false;
          });
          _loadNativeAd();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameInpController = TextEditingController();

    return Scaffold(
      drawer: const SideNavBar(),
      appBar: AppBar(
        titleTextStyle: headingStyle.copyWith(fontSize: 20),
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehaviour(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Change Name",
                  style: headingStyle.copyWith(fontSize: 22),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryForegroundColor,
                    constraints: const BoxConstraints(
                      minWidth: 260,
                      maxWidth: 260,
                    ),
                    contentPadding: const EdgeInsets.all(7.5),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: primaryForegroundColor, width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: secondaryForegroundColor, width: 3),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50))),
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: MaterialStateColor.resolveWith(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return buttonColor;
                      }
                      return Colors.grey;
                    }),
                    hintStyle: captionStyle.copyWith(
                        fontSize: 18, color: const Color(0xff6f7076)),
                    hintText: "Enter New Name",
                  ),
                  style:
                      captionStyle.copyWith(fontSize: 18, color: Colors.white),
                  controller: nameInpController,
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(125, 0, 125, 0),
                  child: MaterialButton(
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      if (nameInpController.text.isNotEmpty) {
                        usernameObj.setName(nameInpController.text);
                        Fluttertoast.showToast(
                            msg: "Name Updated Successfully",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: secondaryForegroundColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Name Cannot Be Empty",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                            backgroundColor: secondaryForegroundColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    color: buttonColor,
                    child: const Text(
                      "Save",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Notification Settings",
                  style: headingStyle.copyWith(fontSize: 22),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Select when you need weather update notifications to be delivered :",
                  style: captionStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Morning Updates",
                          style: headingStyle.copyWith(fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          "Triggered at 06:30 AM Daily",
                          style: captionStyle.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    Switch(
                      value: morningSaved,
                      activeColor: buttonColor,
                      onChanged: (value) async {
                        carrierObj.setMorningStatus(value);
                        setState(() {
                          morningSaved = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Noon Updates",
                          style: headingStyle.copyWith(fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          "Triggered at 12:30 PM Daily",
                          style: captionStyle.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    Switch(
                      value: noonSaved,
                      activeColor: buttonColor,
                      onChanged: (value) async {
                        carrierObj.setNoonStatus(value);
                        setState(() {
                          noonSaved = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Night Updates",
                          style: headingStyle.copyWith(fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          "Triggered at 08:30 PM Daily",
                          style: captionStyle.copyWith(fontSize: 17),
                        ),
                      ],
                    ),
                    Switch(
                      value: nightSaved,
                      activeColor: buttonColor,
                      onChanged: (value) async {
                        carrierObj.setNightStatus(value);
                        setState(() {
                          nightSaved = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Not Receiving Notifications Properly ?",
                  style: headingStyle.copyWith(fontSize: 22),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Make sure Alarms and Reminders setting is enabled, Goto App Info -> "
                  "Alarms and reminders -> Turn on Allow setting alarms and reminders"
                  "\nAlso, Be aware that certain device manufacturers may limit background activities across all apps to conserve battery life, potentially causing delays or non-delivery of notifications."
                  "\nIt's suggested to use the app often.",
                  style: headingStyle.copyWith(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 20,
                ),
                showBatteryExempt
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          shape: const ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () async {
                            AppSettings.openAppSettings(type: AppSettingsType.batteryOptimization, );

                          },
                          color: buttonColor,
                          child: const Text(
                            "Disable Battery Optimization",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    onPressed: () {
                      launchUrlString("https://dontkillmyapp.com/",
                          mode: LaunchMode.externalApplication);
                    },
                    color: buttonColor,
                    child: const Text(
                      "Know More",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                _isNativeLoaded
                    ? Container(
                        margin: EdgeInsets.only(top: 15, bottom: 15),
                        color: primaryForegroundColor,
                        width: double
                            .infinity, // Native ads usually take full width
                        height: 120,

                        child: AdWidget(ad: _nativeAd!),
                      )
                    : Container(
                        height: 135,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
