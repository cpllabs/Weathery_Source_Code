import 'package:flutter/material.dart';
import 'package:weathery/themeData.dart';
import 'package:fluttertoast/fluttertoast.dart';

class firstStartUp extends StatelessWidget {
  var userName;
  final nameInpController = TextEditingController();
  firstStartUp({usernameObj}) {
    userName = usernameObj;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: primaryForegroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 25,
              ),
              Text(
                "Welcome\nAboard",
                textAlign: TextAlign.center,
                style: headingStyle,
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Enter Your Name to Begin",
                textAlign: TextAlign.center,
                style: captionStyle,
              ),
              const SizedBox(
                height: 25,
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
                      borderSide:
                          BorderSide(color: secondaryForegroundColor, width: 3),
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
                  hintText: "Enter Name",
                ),
                style: captionStyle.copyWith(fontSize: 18, color: Colors.white),
                controller: nameInpController,
              ),
              const SizedBox(
                height: 25,
              ),
              TextButton(
                  style: ButtonStyle(
                    textStyle: const MaterialStatePropertyAll<TextStyle>(
                        TextStyle(fontSize: 16)),
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(buttonColor),
                    foregroundColor:
                        const MaterialStatePropertyAll<Color>(Colors.white),
                    shape: const MaterialStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (nameInpController.text.isNotEmpty) {
                      userName.setName(nameInpController.text);
                      Navigator.pushReplacementNamed(context, "/normal");
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 10),
                      Text("Continue"),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                    ],
                  )),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
