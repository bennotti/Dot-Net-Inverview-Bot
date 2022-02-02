import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Custom scroll behaviour for the the [ChatView].
class CustomScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
