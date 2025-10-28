import 'package:flutter/material.dart';

class CustomMaterialRoute extends MaterialPageRoute {
  CustomMaterialRoute({required super.builder, required this.duration}) : super();

  final Duration duration;

  @override
  Duration get transitionDuration => duration;
}
