import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get screenWidth => mediaQuery.size.width;

  double get screenHeight => mediaQuery.size.height;

  double get screenShortestSide => mediaQuery.size.shortestSide;

  double get screenLongestSide => mediaQuery.size.longestSide;

  bool get isSmallScreen => screenShortestSide < 360;

  bool get isMediumScreen =>
      screenShortestSide >= 360 && screenShortestSide < 600;

  bool get isLargeScreen => screenShortestSide >= 600;

  double get statusBarHeight => mediaQuery.padding.top;

  double get bottomBarHeight => mediaQuery.padding.bottom;

  double get appBarHeight => kToolbarHeight + statusBarHeight;

  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  bool get isKeyboardVisible => viewInsets.bottom > 0;

  NavigatorState get navigator => Navigator.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
      ),
    );
  }

  Future<T?> push<T>(Widget page) {
    return navigator.push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void pop<T>([T? result]) {
    navigator.pop<T>(result);
  }

  bool get isDarkMode => theme.brightness == Brightness.dark;
}
