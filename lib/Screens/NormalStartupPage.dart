import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathery/Functionalities/DataProviders.dart';

import "../semiWidgets.dart";
import '../Functionalities/apiData.dart';
import 'package:flutter/material.dart';
import '../themeData.dart';

class NormalStartUp extends ConsumerStatefulWidget {
  NormalStartUp({Key? key}) : super(key: key) {
    getCurrentLocation(defaultCallCheck: true);
  }

  @override
  _NormalStartUpState createState() => _NormalStartUpState();
}

class _NormalStartUpState extends ConsumerState<NormalStartUp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: primaryForegroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.only(right: 30, left: 30),
            padding: EdgeInsets.only(top: 25, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 35,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Hero(
                      tag: "greeting",
                      child: Text(
                        ref.read(
                            greetingProvider), // Use the value from provider
                        style: headingStyle.copyWith(fontSize: 28),
                      ).animate().fade(duration: 0.5.seconds, delay: 500.ms),
                    ),
                    Hero(
                      tag: "name",
                      child: Text(
                        ref
                            .read(userNameProvider)
                            .getName(), // Use the value from provider
                        style: headingStyle.copyWith(fontSize: 26),
                      )
                          .animate()
                          .fade(duration: 0.5.seconds, delay: 1.5.seconds),
                    ),
                  ],
                ),
                Container(
                  child: RotationAnimation(
                    childToRotate: Image.asset(
                      "assets/weathery_loading_icon.png",
                      width: 125,
                    ),
                  ),
                ).animate().fade(duration: 1.seconds, delay: 2.25.seconds),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
