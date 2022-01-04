import 'package:flutter/material.dart';

import 'UI/search2.0.dart';

class AnimatedText extends StatefulWidget {
  AnimatedText({Key? key}) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late final AnimationController animate =
      AnimationController(vsync: this, duration: Duration(seconds: 10));
  late final Animation<double> opac = CurvedAnimation(
      parent: animate, curve: Interval(0.0, 0.3, curve: Curves.easeOutSine));

  @override
  void dispose() {
    super.dispose();
    animate.dispose();
  }

  @override
  void initState() {
    super.initState();
    animate.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FadeTransition(
        opacity: opac,
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Text(
            'Awesome Weather',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 70,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  AnimatedButton({Key? key}) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController animate =
      AnimationController(vsync: this, duration: Duration(seconds: 6));
  late final Animation<Offset> _offset =
      Tween<Offset>(begin: Offset(1.5, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
              parent: animate,
              curve: Interval(0.3, 0.7, curve: Curves.bounceOut)));

  @override
  void dispose() {
    super.dispose();
    animate.dispose();
  }

  @override
  void initState() {
    super.initState();
    animate.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.23,
      child: SlideTransition(
        position: _offset,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (c, a1, a2) => SearchPage(
                  forecast: {},
                  location: {},
                ),
                transitionsBuilder: (c, anim, a2, child) => FadeTransition(
                  opacity: anim,
                  child: child,
                ),
                transitionDuration: Duration(milliseconds: 500),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Search your city",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 40,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
