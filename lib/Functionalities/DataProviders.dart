import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathery/Functionalities/localValues.dart';

final FavouriteLocations favLocOBJ = FavouriteLocations();
final UserName userNameOBJ = UserName();

final userNameProvider = Provider<UserName>((ref) => userNameOBJ);
final favLocationProvider = Provider<FavouriteLocations>((ref) {
  return favLocOBJ;
});
final greetingProvider = Provider<String>((ref) {
  return Greetings().getMessage();
});

final removeAlertProvider = StateProvider<bool>((ref) => false);
