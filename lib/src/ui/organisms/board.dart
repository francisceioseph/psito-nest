import 'dart:math';

import 'package:flutter/material.dart';

import '../../game/game_controller.dart';
import '../molecules/album.dart';
import 'nest.dart';

const _maxSide = 580.0;

/// The nest and, under it, the album of birds.
class Board extends StatelessWidget {
  const Board({super.key, required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: game,
    builder: (context, _) => LayoutBuilder(
      builder: (context, box) {
        final album = box.maxHeight > 300 && box.maxWidth > 360;
        final room = box.maxHeight - 24 - (album ? albumHeight + 8 : 0);
        final side = min(_maxSide, min(box.maxWidth - 24, room));
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Nest(game: game, side: max(side, 80)),
            if (album) ...[
              const SizedBox(height: 8),
              Album(unlocked: game.unlocked),
            ],
          ],
        );
      },
    ),
  );
}
