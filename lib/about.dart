import 'package:flutter/material.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:weathery/semiWidgets.dart';
import 'package:weathery/themeData.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IronSource.hideBanner();
    return Scaffold(
      drawer: SideNavBar(),
      appBar: AppBar(
        titleTextStyle: headingStyle.copyWith(fontSize: 25),
        title: const Text("About"),
        centerTitle: true,
      ),
      body: Container(
          color: secondaryForegroundColor,
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/weathery_icon.png",
                  scale: 3.5,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Weathery",
                  style: headingStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Version : 1.1.0",
                  style: captionStyle,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Weathery is a Weather App built with Flutter using Weather.com API which "
                  "provides weather updates and alerts to users. Weathery filters out unnecessary "
                  "information that don't matter to normal people",
                  style:
                      captionStyle.copyWith(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Project By : AryanshDev",
                  style: headingStyle.copyWith(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          )),
    );
  }
}
