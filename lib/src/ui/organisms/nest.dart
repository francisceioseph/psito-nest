import 'dart:math';

import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../game/game_controller.dart';
import '../../game/game_state.dart';
import '../atoms/bird_art.dart';
import '../atoms/colors.dart';
import '../molecules/tile_motion.dart';

const _gap = 10.0;
const _minSwipe = 24.0;

/// The four by four nest, where the birds slide with the arrows or a swipe.
class Nest extends StatefulWidget {
  const Nest({super.key, required this.game, required this.side});

  final GameController game;
  final double side;

  @override
  State<Nest> createState() => _NestState();
}

class _NestState extends State<Nest> {
  Offset _drag = Offset.zero;

  void _endDrag() {
    final dx = _drag.dx;
    final dy = _drag.dy;
    _drag = Offset.zero;
    if (max(dx.abs(), dy.abs()) < _minSwipe) return;
    widget.game.slide(
      dx.abs() > dy.abs()
          ? (dx > 0 ? Direction.right : Direction.left)
          : (dy > 0 ? Direction.down : Direction.up),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = widget.game;
    final state = game.state;
    final cell = (widget.side - _gap * (boardSize + 1)) / boardSize;
    Offset place(int index) => Offset(
      _gap + (index % boardSize) * (cell + _gap),
      _gap + (index ~/ boardSize) * (cell + _gap),
    );
    Widget positioned(Tile tile, Widget child) {
      final at = place(tile.cell);
      return AnimatedPositioned(
        key: ValueKey(tile.id),
        duration: slideTime,
        curve: Curves.easeOut,
        left: at.dx,
        top: at.dy,
        width: cell,
        height: cell,
        child: child,
      );
    }

    return Semantics(
      container: true,
      label: l10n.nestDescription(
        state.tiles.isEmpty ? '' : birdName(l10n, state.highest),
        state.freeCells.length,
      ),
      onScrollUp: () => game.slide(Direction.up),
      onScrollDown: () => game.slide(Direction.down),
      onScrollLeft: () => game.slide(Direction.left),
      onScrollRight: () => game.slide(Direction.right),
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onPanStart: (_) => _drag = Offset.zero,
        onPanUpdate: (details) => _drag += details.delta,
        onPanEnd: (_) => _endDrag(),
        child: Container(
          key: ValueKey('nest-${game.gameId}'),
          width: widget.side,
          height: widget.side,
          decoration: BoxDecoration(
            color: PsitoColors.frame,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              for (var index = 0; index < cellCount; index++)
                Positioned(
                  left: place(index).dx,
                  top: place(index).dy,
                  width: cell,
                  height: cell,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: PsitoColors.slot,
                      borderRadius: BorderRadius.circular(cell * .13),
                    ),
                  ),
                ),
              for (final ghost in state.ghosts)
                positioned(ghost, Fading(child: BirdArt(ghost.level))),
              for (final tile in state.tiles)
                positioned(
                  tile,
                  Hatch(key: ValueKey(tile.level), child: BirdArt(tile.level)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
