import 'package:flutter/material.dart';

SliverList sliverList({required Widget child}) {
  return SliverList(
    delegate: SliverChildListDelegate(
      <Widget>[child],
    ),
  );
}

// You can also create additional default widgets if necessary
Container defaultContainer({
  required Widget child,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  Color? color,
  double borderRadius = 15.0,
  BoxShadow? boxShadow,
}) {
  return Container(
    padding: padding ?? const EdgeInsets.all(10),
    margin: margin ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    decoration: BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        boxShadow ?? BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    ),
    child: child,
  );
}
