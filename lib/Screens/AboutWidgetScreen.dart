import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../semiWidgets.dart';
import '../themeData.dart';

class AboutWidgetScreen extends StatelessWidget {
  const AboutWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // IronSource.hideBanner();
    return Scaffold(
        drawer: SideNavBar(),
        appBar: AppBar(
          titleTextStyle: headingStyle.copyWith(fontSize: 20),
          title: const Text("Home Widget"),
          centerTitle: true,
        ),
        body: ScrollConfiguration(
          behavior: NoGlowScrollBehaviour(),
          child: SingleChildScrollView(
            child: Container(
                color: secondaryForegroundColor,
                padding: const EdgeInsets.all(14),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "HomeScreen Widget Guide",
                        style: headingStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "The Home Screen Widget gives you updates without opening the "
                            "app directly on your home screen!!\nIt is Updated every 3 "
                            "Hours due to Android and Free Tier Data Limitations",
                        style: captionStyle.copyWith(fontSize: 16),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        "All Device Restrictions Mentioned In Settings Apply To This Also!",
                        style: captionStyle.copyWith(fontSize: 16, fontStyle: FontStyle.italic, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Image.asset(
                        "assets/widgetguide.png",
                        height: 250,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 7.5,
                        children: [
                          Text("1 - Icon Representing Weather Condition",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          Text("2 - Temperature",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          Text("3 - Weather Condition Description",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          Text("4 - Location Of The Displayed Details",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          SizedBox(
                            height: 0,
                          ),
                          Text("Icons",
                              style: headingStyle.copyWith(
                                fontSize: 20,
                              )),
                          Text(
                              "Icons Turn White To Indicate They Are Active.",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          Text(
                              "5 - Represents Rain : Active Icon Means Chances Of Rain - Umbrella Recommended",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          Text(
                              "6 - Represents Alerts : Active Icon Means Active Alerts In Area",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          Text(
                              "7 - Represents Pollution : Active Icon Mask Is Recommended",
                              style: captionStyle.copyWith(
                                  fontSize: 16, color: Colors.white)),
                          SizedBox(height: 100,)
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}
