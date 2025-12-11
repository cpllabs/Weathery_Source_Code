import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:weathery/APIKeys.dart';
import 'package:weathery/Functionalities/ClothingData.dart';
import 'package:weathery/Functionalities/localValues.dart';
import 'package:weathery/semiWidgets.dart';
import '../themeData.dart';

class ClothingScreen extends StatefulWidget {
  final String desc;
  final double temp;
  final int uv;
  final int aqi;
  ClothingScreen(
      {super.key,
      required this.desc,
      required this.temp,
      required this.uv,
      required this.aqi});

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen> {
  NativeAd? _nativeAd;
  bool _isNativeLoaded = false;
  @override
  void initState() {
    _loadNativeAd();
    super.initState();
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
      adUnitId: ADMOB_APP_ID,
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
          //  _loadNativeAd();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    var data = (WeatherOutfitService.getOutfitRecommendations(
        temperature: widget.temp,
        currentDescription: widget.desc,
        uvIndex: (widget.uv)));
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(0),
        color: primaryForegroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: primaryBackgroundColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30))),
          margin: EdgeInsets.only(top: 45),
          child: ScrollConfiguration(
            behavior: NoGlowScrollBehaviour(),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      spacing: 15,
                      children: [
                        InkWell(
                          onTap: context.pop,
                          child: Icon(
                            Bootstrap.arrow_left,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Cloth Styling Guide",
                          style: headingStyle.copyWith(fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      "This guide suggests what colors and material"
                      " of fabric to wear based on current weather conditions. (BETA)",
                      style: captionStyle.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Container(
                      // Type
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.5, horizontal: 7.5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: primaryForegroundColor,
                      ),
                      margin: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 20,
                        children: [
                          Text(
                            "Suggested Clothing",
                            style: headingStyle.copyWith(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 15,
                              runSpacing: 10,
                              children: data["cloths"]!
                                  .map((ele) => DisplayContainer(
                                        textToDiplay: ele,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Container(
                      // Type
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.5, horizontal: 7.5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: primaryForegroundColor,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 20,
                        children: [
                          Text(
                            "Fabric Suggested",
                            style: headingStyle.copyWith(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 15,
                              runSpacing: 10,
                              children: data["material"]!
                                  .map((ele) => DisplayContainer(
                                        textToDiplay: ele,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Container(
                      // Type
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.5, horizontal: 7.5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: primaryForegroundColor,
                      ),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        spacing: 20,
                        children: [
                          Text(
                            "Suggested Colors",
                            style: headingStyle.copyWith(fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 15,
                              runSpacing: 10,
                              children: data["colors"]!
                                  .map((ele) => buildColorChip(ele))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7.5,
                    ),
                    Container(
                      // Type
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.5, horizontal: 7.5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: primaryForegroundColor,
                      ),

                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          spacing: 20,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 15,
                                children: [
                                  Text(
                                    "Mask",
                                    style: headingStyle.copyWith(fontSize: 22),
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(
                                    Icons.masks_sharp,
                                    size: 60,
                                    color: widget.aqi > 3
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                  Text(
                                    widget.aqi > 3
                                        ? "Wearing Mask Is Recommended"
                                        : "Can Go Out Without Mask",
                                    style: captionStyle.copyWith(
                                        fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            VerticalDivider(
                              thickness: 1,
                              width: 1,
                              indent: 7.5,
                              endIndent: 7.5,
                              color: secondaryTextColor,
                            ),
                            Expanded(
                              child: Column(
                                spacing: 15,
                                children: [
                                  Text(
                                    "UV Protection",
                                    style: headingStyle.copyWith(fontSize: 22),
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(AntDesign.skin_twotone,
                                      size: 60,
                                      color: widget.uv >= 6
                                          ? Colors.white
                                          : Colors.white54),
                                  Text(
                                    widget.uv >= 8
                                        ? "Use Sun Protection and Umbrella"
                                        : widget.uv >= 6
                                            ? "Apply Sun Protection"
                                            : "Protection Not Much Needed",
                                    style: captionStyle.copyWith(
                                        fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _isNativeLoaded ? AdWidget(ad: _nativeAd!) : Container(),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayContainer extends StatelessWidget {
  String textToDiplay;
  DisplayContainer({super.key, required this.textToDiplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 17.5),
      decoration: BoxDecoration(
        color: primaryBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(this.textToDiplay,
          style: captionStyle.copyWith(color: Colors.white, fontSize: 16)),
    );
  }
}

Widget buildColorChip(String colorName) {
  return Container(
    padding: EdgeInsets.fromLTRB(10, 7.5, 5, 7.5),
    decoration: BoxDecoration(
      color: primaryBackgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 7.5,
      children: [
        Text(
          colorName,
          style: TextStyle(
            // Switch text color based on background darkness roughly
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Container(
          height: 22.5,
          width: 22.5,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: OutfitColorMapper.getGradient(colorName),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    ),
  );
}
