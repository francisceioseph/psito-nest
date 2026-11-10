import 'package:flutter/material.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

abstract final class PsitoColors {
  static const felt = Color(0xFF8A5A3A);
  static const feltGlow = Color(0xFFA06E4A);
  static const feltDark = Color(0xFF6B4329);
  static const feltLight = Color(0xFFC9A98A);
  static const cream = Color(0xFFF6EED6);
  static const black = Color(0xFF3B3842);
  static const frame = Color(0xFF4A2E1C);
  static const slot = Color(0xFF5E3C27);
  static const onFelt = Color(0xFFF7EFE0);
  static const onFeltMuted = Color(0xFFE2CDB4);
  static const barTop = Color(0xFF5E3B25);
  static const barBottom = Color(0xFF4C2F1D);
}

/// The nest in the tree, for the shared widgets.
const nestPalette = GamePalette(
  felt: PsitoColors.felt,
  feltGlow: PsitoColors.feltGlow,
  feltDark: PsitoColors.feltDark,
  feltLight: PsitoColors.feltLight,
  barTop: PsitoColors.barTop,
  barBottom: PsitoColors.barBottom,
  onFelt: PsitoColors.onFelt,
  onFeltMuted: PsitoColors.onFeltMuted,
  cream: PsitoColors.cream,
  ink: PsitoColors.black,
);
