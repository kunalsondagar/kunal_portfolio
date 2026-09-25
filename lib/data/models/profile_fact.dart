import 'package:flutter/material.dart';

/// A single fact shown in the About section, e.g. "Location — Surat, Gujarat".
class ProfileFact {
  const ProfileFact({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}
