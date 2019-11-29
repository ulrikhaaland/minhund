import 'package:flutter/material.dart';
import 'package:minhund/service/service_provider.dart';
import 'show_up.dart';
import 'dart:async';

class Intro extends StatefulWidget {
  final VoidCallback introDone;

  const Intro({Key key, this.introDone}) : super(key: key);
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final int _delay = 1200;

  @override
  void initState() {
    Timer(Duration(milliseconds: _delay + 1000), () => widget.introDone());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ServiceProvider
          .instance.instanceStyleService.appStyle.backgroundColor,
      body: Center(
          child: ShowUp(
              delay: _delay,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Image.asset(
                  //   "lib/assets/images/Layer4.png",
                  //   scale: 3,
                  // ),
                  Text(
                    "Min Hund",
                    style: TextStyle(
                        fontFamily: "Apercu",
                        color: ServiceProvider
                            .instance.instanceStyleService.appStyle.textGrey,
                        fontSize: 50),
                  ),
                ],
              ))),
    );
  }
}
