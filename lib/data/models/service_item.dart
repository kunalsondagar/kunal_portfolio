import 'package:flutter/material.dart';

/// A service offered in the "What I do" section.
class ServiceItem {
  const ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<String> points;
}
