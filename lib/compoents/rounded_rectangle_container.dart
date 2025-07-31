import 'package:flutter/material.dart';

class RoundedRectangleContainer extends StatelessWidget {
  const RoundedRectangleContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    required this.outerColor,
    required this.innerColor,
    this.borderRadius = 16.0,
  }) : super(key: key);

  final double width;
  final double height;
  final Widget child;
  final Color outerColor;
  final Color innerColor;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: Colors.black.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              color: outerColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: Container(
                    color: innerColor,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
