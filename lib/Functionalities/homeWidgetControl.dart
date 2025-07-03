import 'package:home_widget/home_widget.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';


@pragma('vm:entry-point')
void updateWidgetData(String iconPath, int temperature, String description,
    String location, bool showUmbrella, bool showMask, bool showWarning) async {
  await HomeWidget.saveWidgetData<String>(
      'temp', temperature.toString()); // Ensure int
  await HomeWidget.saveWidgetData<String>('desc', description);
  await HomeWidget.saveWidgetData<String>("location", location);
  await HomeWidget.saveWidgetData<bool>('showUmbrellaIcon', showUmbrella);
  await HomeWidget.saveWidgetData<bool>('showMaskIcon', showMask);
  await HomeWidget.saveWidgetData<bool>('showWarningIcon', showWarning);
  await HomeWidget.saveWidgetData<String>(
      'iconPath', await getWeatherIcon(iconPath));
  await HomeWidget.updateWidget(androidName: "MainWidget");
}

Future<dynamic> getWeatherIcon(String iconPath) async {
  try {
    // Get app's internal storage directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/weather_icon.png';

    // Load image from assets
    ByteData data = await rootBundle.load("assets/$iconPath");
    List<int> bytes = data.buffer.asUint8List();

    // Save image to internal storage
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  } catch (e) {}
}
