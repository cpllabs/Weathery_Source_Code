import 'package:weathery/notifications.dart';

import "semiWidgets.dart";
import 'apiData.dart';
import 'package:flutter/material.dart';
import 'themeData.dart';
import 'main.dart';

class NormalStartUp extends StatefulWidget {
  NormalStartUp({Key? key}) : super(key: key) {
    getCurrentLocation();

  }

  @override
  State<NormalStartUp> createState() => _NormalStartUpState();
}

class _NormalStartUpState extends State<NormalStartUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          decoration: BoxDecoration(
            color: primaryForegroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "Welcome",
                    style:headingStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(35, 15, 35, 0),
                  child: RotationAnimation(
                    childToRotate: Image.asset(
                      "assets/weathery_loading_icon.png",),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
