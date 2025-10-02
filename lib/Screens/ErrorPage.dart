import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weathery/themeData.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 7.5,
            children: [
              Text(
                "Woohh! Didn't Expect You Here!",
                style: headingStyle.copyWith(fontSize: 23),
              ),
              Text(
                "This Route Is Either Incomplete Or Doesn't Exists",
                style: captionStyle.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 45,
              ),
              MaterialButton(
                splashColor: Colors.transparent,
                onPressed: () {
                  context.go("/normal");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text("Take Me Home", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
