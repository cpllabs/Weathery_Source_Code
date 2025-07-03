import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ironsource_mediation/ironsource_mediation.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weathery/apiData.dart';
import 'package:weathery/mainScreen.dart';
import 'package:weathery/themeData.dart';
import 'main.dart';

var currentSearchBarContext;
List<Widget> favsHolders = [SizedBox(),SizedBox(),SizedBox(),SizedBox()];

void alertUser(
    {required Widget title,
    required Widget content,
    required List<Widget> actions}) {
  showDialog(
    barrierDismissible: false,
    context: globalNavigatorKey.currentContext!,
    builder: (BuildContext _) {
      return AlertDialog(
        title: title,
        titleTextStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        content: content,
        actions: actions,
        backgroundColor: secondaryForegroundColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      );
    },
  );
}

void alertUserAsync(
    {required Widget title,
    required Widget content,
    required List<Widget> actions}) async {
  showDialog(
    context: globalNavigatorKey.currentContext!,
    builder: (BuildContext _) {
      return AlertDialog(
        title: title,
        titleTextStyle:
            const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        content: content,
        actions: actions,
        actionsAlignment: MainAxisAlignment.center,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: secondaryForegroundColor,
      );
    },
  );
}

class RotationAnimation extends StatefulWidget {
  RotationAnimation({required this.childToRotate});
  Widget childToRotate;
  @override
  _RotationAnimationState createState() =>
      _RotationAnimationState(widgetToRotate: childToRotate);
}

class _RotationAnimationState extends State<RotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  _RotationAnimationState({required this.widgetToRotate});
  Widget widgetToRotate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutCirc));
    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Center(
        child: Container(
          child: widgetToRotate,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NoGlowScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SearchBar extends StatefulWidget {

  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();

}

class _SearchBarState extends State<SearchBar> {
  updateSearchBarState(){

    setState(() {
      if (favLocationPref.getFavLocation(1) != null){
        favsHolders[0] = FavouriteLocationWidget(slotNum: 1 , updfnc: updateSearchBarState);
      }
      else{
        favsHolders[0] = EmptyFavouriteLocation(numSlot: 1, updfnc: updateSearchBarState,);
      }
      if (favLocationPref.getFavLocation(2) != null){
        favsHolders[1] = FavouriteLocationWidget(slotNum: 2, updfnc: updateSearchBarState);
      }
      else{
        favsHolders[1] = EmptyFavouriteLocation(numSlot: 2, updfnc: updateSearchBarState);
      }

      if (favLocationPref.getFavLocation(3) != null){
        favsHolders[2] = FavouriteLocationWidget(slotNum: 3, updfnc: updateSearchBarState);
      }
      else{
        favsHolders[2] = EmptyFavouriteLocation(numSlot: 3, updfnc: updateSearchBarState);
      }

      if (favLocationPref.getFavLocation(4) != null){
        favsHolders[3] = FavouriteLocationWidget(slotNum: 4, updfnc: updateSearchBarState);
      }
      else{
        favsHolders[3] = EmptyFavouriteLocation(numSlot: 4, updfnc: updateSearchBarState);
      }

    });
  }
  TextEditingController searchController = TextEditingController();
_SearchBarState(){
  if (favLocationPref.getFavLocation(1) != null){
    favsHolders[0] = FavouriteLocationWidget(slotNum: 1, updfnc: updateSearchBarState);
  }
  else{
    favsHolders[0] = EmptyFavouriteLocation(numSlot: 1, updfnc: updateSearchBarState,);
  }
  if (favLocationPref.getFavLocation(2) != null){
    favsHolders[1] = FavouriteLocationWidget(slotNum: 2, updfnc: updateSearchBarState,);
  }
  else{
    favsHolders[1] = EmptyFavouriteLocation(numSlot: 2, updfnc: updateSearchBarState);
  }

  if (favLocationPref.getFavLocation(3) != null){
    favsHolders[2] = FavouriteLocationWidget(slotNum: 3, updfnc: updateSearchBarState);
  }
  else{
    favsHolders[2] = EmptyFavouriteLocation(numSlot: 3, updfnc: updateSearchBarState);
  }
  if (favLocationPref.getFavLocation(4) != null){
    favsHolders[3] = FavouriteLocationWidget(slotNum: 4, updfnc: updateSearchBarState);
  }
  else{
    favsHolders[3] = EmptyFavouriteLocation(numSlot: 4, updfnc: updateSearchBarState);
  }
}
  List<Widget> suggestions = [];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 7.5, 5, 0),
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: secondaryForegroundColor,
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      suffixIcon: SizedBox(
                        width: 40,
                        child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            child: const Icon(
                              Icons.close,
                              size: 30,
                            ),
                            onPressed: () {
                              closeSearchOverlay();
                            }),
                      ),
                      contentPadding: const EdgeInsets.only(left: 15),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.5, color: secondaryTextColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1.5, color: secondaryTextColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          )),
                    ),
                    autofocus: true,
                    controller: searchController,
                    style: headingStyle.copyWith(fontSize: 18),
                    onEditingComplete: () async {
                      suggestions.clear();
                      setState(() {
                        suggestions.add(
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            height: 75,
                            width: 75,
                            child: RotationAnimation(
                              childToRotate: Image.asset(
                                "assets/weathery_loading_icon.png",
                              ),
                            ),
                          ),
                        );
                      });
                      var cities =
                          await searchlocationNames(str: searchController.text);
                      setState(() {
                        suggestions.clear();
                      });
                      for (int i = 0; i < cities.length; i++) {
                        var city = cities[i];
                        setState(() {
                          suggestions.add(SearchSuggestionObject(city["name"],
                              city["region"] + ", " + city["country"]));
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 7.5),
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehaviour(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: favsHolders[0],
                              ),
                              Expanded(
                                child: favsHolders[1],
                              ),

                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: favsHolders[2],
                              ),
                              Expanded(
                                child: favsHolders[3],
                              ),

                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                           Divider(
                            thickness: 1.25,
                            indent: 10,
                            endIndent: 10,
                            color: secondaryTextColor,
                          ),
                          Column(
                            children: suggestions,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

class SearchSuggestionObject extends StatelessWidget {
  var locationCity, country_region;

  SearchSuggestionObject(location, countryregion) {
    locationCity = location;
    country_region = countryregion;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
      onPressed: () {
        closeSearchOverlay();
        getWeatherFromName(city: "$locationCity,$country_region");
        IronSource.displayBanner();
        alertUser(
            title: const SizedBox(
              height: 0,
              width: 0,
            ),
            content: SizedBox(
              height: 120,
              width: 80,
              child: RotationAnimation(
                childToRotate: Image.asset(
                  "assets/weathery_loading_icon.png",
                  height: 150,
                ),
              ),
            ),
            actions: [
              const SizedBox(
                height: 0,
                width: 0,
              )
            ]);
      },
      splashColor: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            locationCity,
            style: headingStyle.copyWith(fontSize: 20),
          ),
          Text(
            country_region,
            style: captionStyle.copyWith(fontSize: 15),
          )
        ],
      ),
    );
  }
}

OverlayEntry? SearchOverlayEntry;
void showSearchOverlay(BuildContext context) {
  IronSource.displayBanner();
  currentSearchBarContext = context;
  SearchOverlayEntry = OverlayEntry(
    builder: (context) => const SearchBar(),
  );
  final overlay = Overlay.of(context);
  overlay.insert(SearchOverlayEntry!);
}

void closeSearchOverlay() {
  IronSource.hideBanner();
  SearchOverlayEntry!.remove();
}

class SideNavBar extends StatefulWidget {
  const SideNavBar({Key? key}) : super(key: key);

  @override
  _SideNavBarState createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 300,
      backgroundColor: secondaryForegroundColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/bg/bg_mount.jpg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter)),
              child: Container(
                color: secondaryForegroundColor.withAlpha(110),
              ),
            ),
            const SizedBox(
              height: 7.5,
            ),
            NavBarItem(Icons.home, "Home", () {
              Navigator.pushReplacementNamed(
                  globalNavigatorKey.currentContext!, "/main");
            }),
            const SizedBox(
              height: 5,
            ),
            NavBarItem(Icons.star, "Rate", () {
              launchUrlString(
                  "https://play.google.com/store/apps/details?id=com.CPLLabs.weathery",
                  mode: LaunchMode.externalNonBrowserApplication);
            }),
            const SizedBox(
              height: 5,
            ),
            NavBarItem(Icons.question_mark_outlined, "About", () {
              Navigator.pushReplacementNamed(
                  globalNavigatorKey.currentContext!, "/about");
            }),
            NavBarItem(Icons.settings, "Settings", () {
              Navigator.pushReplacementNamed(
                  globalNavigatorKey.currentContext!, "/settings");
            }),
            NavBarItem(Icons.privacy_tip_sharp, "Privacy Policy", () {
              launchUrlString(
                  "https://aryanshdev.github.io/Weathery/privacy.html",
                  mode: LaunchMode.externalApplication);
            }),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 50, // Adjust ad container height as needed
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  IconData? icon;
  String? nameText;
  void Function()? onpress;
  NavBarItem(IconData ico, String text, Onpress) {
    icon = ico;
    nameText = text;
    onpress = Onpress;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(10),
      elevation: 5,
      splashColor: primaryBackgroundColor,
      onPressed: () {
        IronSource.hideBanner();
        onpress!();
      },
      child: Row(
        children: [
          Expanded(
            child: Icon(
              icon!,
              size: 27.5,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              nameText!,
              style: headingStyle.copyWith(fontSize: 18),
              textAlign: TextAlign.start,
            ),
          )
        ],
      ),
    );
  }
}

class ForecastDisplayObject extends StatelessWidget {
  var temp, time, icon, desc;
  ForecastDisplayObject(@required dataObjct) {
    desc = dataObjct["condition"]["text"];
    icon = dataObjct["condition"]["icon"].toString().substring(21);
    temp = dataObjct["temp_c"];
    time = DateFormat("h:mm a\nd MMM").format(
        DateTime.fromMillisecondsSinceEpoch(dataObjct["time_epoch"] * 1000));

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      child: Column(
        children: [
          Text(
            time,
            textAlign: TextAlign.center,
          ),
          Image.asset('assets/$icon'),

          Text('$temp °C'),
          Text(
            desc,
            style: captionStyle.copyWith(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class WeatherAlertDisplayObject extends StatelessWidget {
  var heading, alert, body;
  WeatherAlertDisplayObject(@required alertJson, @required bodyTXT) {
    alert = alertJson;
    body = bodyTXT;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: secondaryForegroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            alert["event"],
            style: headingStyle.copyWith(fontSize: 19),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 7.5,
          ),
          Text(
            body,
            style: captionStyle.copyWith(fontSize: 15),
          ),
          const SizedBox(
            height: 9,
          ),
          Text(
            "Issued on: ${formatDate(alert["effective"])}",
            style: captionStyle.copyWith(fontSize: 15),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Valid till: ${formatDate(alert["expires"])}",
            style: captionStyle.copyWith(fontSize: 15),
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Type :\n' + alert["msgtype"],
                style: captionStyle.copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Text(
                "Severity :\n" + alert["severity"],
                style: captionStyle.copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              Text(
                "Urgency :\n" + alert["urgency"],
                style: captionStyle.copyWith(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
    );
  }
}

String formatDate(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString).toLocal();
  return DateFormat("EE, d MMM yyyy 'a't HH:mm a ").format(dateTime) +
      DateTime(0).timeZoneName;
}

void showInternetConnectionWarning() {
  Fluttertoast.showToast(
      msg: "Internet Not Available. Check Your Connection And Try Again",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: secondaryForegroundColor,
      textColor: Colors.white,
      fontSize: 16.0);
  IronSource.hideBanner();
}

initAds() async {
  IronSource.setFlutterVersion('3.13.6');
  IronSource.setLevelPlayBannerListener(BannerListener());
  await IronSource.init(
      appKey: '<APP_KEY>', adUnits: [IronSourceAdUnit.Banner]);
  await IronSource.loadBanner(
      size: IronSourceBannerSize.BANNER,
      position: IronSourceBannerPosition.Bottom);
  IronSource.validateIntegration();

}

class BannerListener extends LevelPlayBannerListener {
  @override
  void onAdLoaded(IronSourceAdInfo adInfo) {
    print(adInfo);
  }

  @override
  void onAdLoadFailed(IronSourceError error) async {
    if (error.errorCode == 606) {
      await IronSource.loadBanner(
          size: IronSourceBannerSize.BANNER,
          position: IronSourceBannerPosition.Bottom);
    }
  }

  @override
  void onAdScreenPresented(IronSourceAdInfo adInfo) {

  }

  @override
  void onAdClicked(IronSourceAdInfo adInfo) {}

  @override
  void onAdLeftApplication(IronSourceAdInfo adInfo) {}

  @override
  void onAdScreenDismissed(IronSourceAdInfo adInfo) {}

// Implement other listener methods similarly, using _state to communicate
}

class EmptyFavouriteLocation extends StatefulWidget {

  final int numSlot;
  final VoidCallback updfnc;
  const EmptyFavouriteLocation({super.key, required this.updfnc, required this.numSlot});

  @override
  State<EmptyFavouriteLocation> createState() => _EmptyFavouriteLocationState(slot:  this.numSlot, updateFunction: this.updfnc);
}

class _EmptyFavouriteLocationState extends State<EmptyFavouriteLocation> {
  int slot  = 0;
  final VoidCallback? updateFunction;
  _EmptyFavouriteLocationState({slot, this.updateFunction}){
    this.slot = slot;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 72.5,
        decoration: BoxDecoration(
            border: Border.all(color: secondaryTextColor.withAlpha(150)),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  "Add Current Location as Favourite",
                  style: captionStyle.copyWith(fontSize: 14.5),
                ),
              ),
            ),
            Expanded(
              child: MaterialButton(
                splashColor: secondaryForegroundColor,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                   favLocationPref.setLoaction(
                      slot,
                      posLat, posLong, userCity, userState, userCountry);
                  updateFunction?.call();
                },
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class FavouriteLocationWidget extends StatefulWidget {
  final int slotNum;
  final VoidCallback updfnc;
  const FavouriteLocationWidget({super.key, required this.updfnc, required this.slotNum});

  @override
  State<FavouriteLocationWidget> createState() => _FavouriteLocationWidget(slotNum:this.slotNum, updateCallback: this.updfnc);
}

class _FavouriteLocationWidget extends State<FavouriteLocationWidget> {

    String lat = "", long = "", city = "", state = "", country = "";
    int slot= 0;
    final VoidCallback updateCallback;
    _FavouriteLocationWidget({slotNum, required this.updateCallback}) {
      slot = slotNum;
      dynamic raw = favLocationPref.getFavLocation(slotNum);
      if (raw != null) {
        List<String> values = raw.split(',');
        lat = values[3];
        long = values[4];
        city = values[0].length > 13  ? '${values[0].substring(0,13)}..' : values[0];
        state = values[1].length > 18  ? '${values[1].substring(0,13)}..' : values[1];
        country =  values[2].length > 20   ? '${values[2].substring(0,19)}..' : values[2]   ;
      }


  }
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        height: 72.5,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            border: Border.all(color: primaryTextColor),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: MaterialButton(
                padding:const EdgeInsets.fromLTRB(6,5.0,0,5.0),
                onPressed: () {
                  closeSearchOverlay();
                  getWeather(lat: lat, long:long);
                  IronSource.displayBanner();
                  alertUser(
                      title: const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                      content: SizedBox(
                        height: 120,
                        width: 80,
                        child: RotationAnimation(
                          childToRotate: Image.asset(
                            "assets/weathery_loading_icon.png",
                            height: 150,
                          ),
                        ),
                      ),
                      actions: [
                        const SizedBox(
                          height: 0,
                          width: 0,
                        )
                      ]);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    Text(
                      "$city",
                      style: headingStyle.copyWith(fontSize: 16),
                    ),
                    Text(
                      "$state",
                      style: captionStyle.copyWith(fontSize: 14),
                    ),
                    Text(
                      "$country",
                      style: captionStyle.copyWith(fontSize:14),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: MaterialButton(
                splashColor: secondaryForegroundColor,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  favLocationPref.deleteFavLocation(slot);
                  updateCallback.call();
                },
                child: Icon(
                  Icons.delete,
                  size: 30,
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
