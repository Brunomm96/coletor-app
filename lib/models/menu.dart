import 'package:flutter/material.dart';

// ignore: camel_case_types
class Menu_App {
  final String id;
  final String title;
  final Color color;
  final Color colorIcon;
  final Icon iconForm;
  final String route;

  const Menu_App({
    required this.id,
    required this.title,
    required this.colorIcon,
    required this.route,
    this.iconForm = const Icon(Icons.inbox),
    this.color = Colors.orange,
  });
}
