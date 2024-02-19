import 'package:flutter/material.dart';

/// InfinityLine
/// Color and height can be set.
/// It is used to create a line that stretches infinitely.
class InfinityLine extends StatelessWidget {
  const InfinityLine({
    super.key,
    required this.height,
    this.color,
  });

  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: color,
    );
  }
}
