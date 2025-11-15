import 'package:flutter/material.dart';

/// Base configuration for dialog actions
///
/// This model defines the structure for action buttons in confirmation dialogs,
/// providing consistent styling and behavior options for buttons like "Cancel",
/// "Delete", "Confirm", etc. across all dialogs in the Graviton app.
class DialogAction {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final FontWeight? fontWeight;
  final bool isDestructive;

  const DialogAction({
    required this.text,
    required this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.fontWeight,
    this.isDestructive = false,
  });
}
