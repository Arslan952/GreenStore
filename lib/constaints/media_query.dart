import 'package:flutter/material.dart';

class MediaQuerySize {
  final BuildContext context;

  MediaQuerySize(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  double get total => height + width;

  /// Orientation check
  bool get isPortrait => MediaQuery.of(context).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(context).orientation == Orientation.landscape;

  /// Device type check (using 600px as a threshold for tablets)
  bool get isTablet => width >= 600;

  /// Adjust font scaling based on screen width (optional)
  double fontScale(double size) => size * (width / 375);

  /// Adjust height scaling based on design proportions
  double heightScale(double size) => size * (height / 812);

  /// Adjust width scaling based on design proportions
  double widthScale(double size) => size * (width / 375);
}
