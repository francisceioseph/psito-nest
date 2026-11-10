import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../game/game_state.dart';
import '../atoms/bird_art.dart';
import '../atoms/colors.dart';

/// The height of the album, under the nest.
const albumHeight = 56.0;

/// The whole chain of birds. The ones not raised yet are only shadows.
class Album extends StatelessWidget {
  const Album({super.key, required this.unlocked});

  final int unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: albumHeight,
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var level = 1; level <= maxLevel; level++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Tooltip(
                  message: level <= unlocked
                      ? birdName(l10n, level)
                      : l10n.birdUnknown,
                  child: SizedBox.square(
                    dimension: albumHeight,
                    child: level <= unlocked
                        ? BirdArt(level)
                        : const DecoratedBox(
                            decoration: BoxDecoration(
                              color: PsitoColors.slot,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.question_mark_rounded,
                                size: 22,
                                color: PsitoColors.feltLight,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
