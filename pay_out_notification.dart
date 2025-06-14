// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home.dart'; // Import your HomeScreen widget

class PayoutnotifiationWidget extends StatefulWidget {
  const PayoutnotifiationWidget({super.key, required Null Function() onContinue});

  @override
  _PayoutnotifiationWidgetState createState() => _PayoutnotifiationWidgetState();
}

class _PayoutnotifiationWidgetState extends State<PayoutnotifiationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleScaleAnimation;
  late Animation<double> _tickScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Total animation duration
      vsync: this,
    );

    // Animation for the green circle: zooms in with an elastic effect
    _circleScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut, // Provides a nice "zoom in and settle" effect
      ),
    );

    // Animation for the tick symbol: scales in slightly after the circle starts
    _tickScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.5, // Starts halfway through the circle animation
          1.0,
          curve: Curves.elasticOut, // Also uses an elastic effect
        ),
      ),
    );

    // Start the animation when the widget is first built
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Center(
        child: SizedBox(
          width: 360, // Original width, consider using MediaQuery for responsiveness
          height: 800, // Original height (consider making this dynamic)
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 92,
                child: const Text(
                  'Congrats\nYour Order Placed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontFamily: 'Yeon Sung',
                      fontSize: 25,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                      height: 1.5),
                ),
              ),

              // The green circle with checkmark graphic, now animated
              Positioned(
                top: 188,
                child: SizedBox(
                  width: 172,
                  height: 162,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          // Main green circle, scaled by _circleScaleAnimation
                          Transform.scale(
                            scale: _circleScaleAnimation.value,
                            child: Container(
                              width: 134,
                              height: 134,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(83, 232, 139, 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Checkmark SVG, scaled by _tickScaleAnimation
                          Transform.scale(
                            scale: _tickScaleAnimation.value,
                            child: Opacity(
                              opacity: _tickScaleAnimation.value,
                              child: SvgPicture.asset(
                                'assets/images/vector.svg',
                                semanticsLabel: 'vector',
                                width: 60,
                                height: 60,
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), // Ensures the SVG is white
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              Positioned(
                top: 400,
                child: GestureDetector(
                  onTap: () {
                    // Navigate to Home Screen and remove all previous routes
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigate to HomeScreen
                          (Route<dynamic> route) => false, // Remove all previous routes from the stack
                    );
                  },
                  child: Container(
                      width: 157,
                      height: 57,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                            begin: Alignment(0.8459399938583374, 0.1310659646987915),
                            end: Alignment(-0.1310659646987915, 0.11150387674570084),
                            colors: [
                              Color.fromRGBO(231, 83, 83, 1),
                              Color.fromRGBO(190, 20, 20, 1)
                            ]),
                      ),
                      child: const Center(
                        child: Text(
                          'Go Home',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontFamily: 'Yeon Sung',
                              fontSize: 16,
                              letterSpacing: 0,
                              fontWeight: FontWeight.normal,
                              height: 1.5),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}