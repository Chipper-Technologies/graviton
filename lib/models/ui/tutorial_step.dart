import 'package:flutter/material.dart';
import 'package:graviton/core/enums/tutorial_action.dart';

/// Represents a single step in the application tutorial
class TutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Rect? highlightArea;
  final TutorialAction? action;
  final bool isLogoStep;

  const TutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    this.highlightArea,
    this.action,
    this.isLogoStep = false,
  });
}
