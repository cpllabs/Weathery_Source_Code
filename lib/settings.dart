import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weathery/localValues.dart';
import 'package:weathery/semiWidgets.dart';
import 'themeData.dart';

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

  @override
  initState() {
    super.initState();
    _init();
  }

  _init() async {
    await carrierObj.initPrefObj();
    setState(() {
      morningSaved = carrierObj.getMorningSavedStatus();
      noonSaved = carrierObj.getNoonSavedStatus();
      nightSaved = carrierObj.getNightSavedStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideNavBar(),
      appBar: AppBar(
        titleTextStyle: headingStyle.copyWith(fontSize: 25),
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Notification Settings",
                style: headingStyle.copyWith(fontSize: 26),
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
                height: 12.5,
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
                        "Triggered at 6:30 AM Daily",
                        style: captionStyle.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  Switch(
                    value: morningSaved,
                    activeColor: buttonColor,
                    onChanged: (value) async{
                      carrierObj.setMorningStatus(value);
                      setState(() {
                        morningSaved = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 12.5,
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
                    onChanged: (value) async{
                      carrierObj.setNoonStatus(value);
                      setState(() {
                        noonSaved = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 12.5,
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
                        "Triggered at 8:00 PM Daily",
                        style: captionStyle.copyWith(fontSize: 17),
                      ),
                    ],
                  ),
                  Switch(
                    value: nightSaved,
                    activeColor: buttonColor,
                    onChanged: (value) async{
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
                height: 7.5,
              ),
              Text(
                "Make sure Alarms and Reminders setting is enabled, Goto App Info -> "
                    "Alarms and reminders -> Turn on Allow setting alarms and reminders"
                    "\nAlso, Be aware that certain device manufacturers may limit background activities across all apps to conserve battery life, potentially causing delays or non-delivery of notifications.",
                style: headingStyle.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 7.5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(100,0,100,0),
                
                child: MaterialButton(
                  shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  onPressed: () {
                    launchUrlString(
                        "https://dontkillmyapp.com/",
                        mode: LaunchMode.externalApplication);
                  },
                  color: buttonColor,
                  child: const Text(
                    "Know More",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
