import 'dart:math';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../game/game_controller.dart';
import '../game/game_state.dart';
import 'colors.dart';

const _slideTime = Duration(milliseconds: 120);
const _gap = 10.0;
const _maxSide = 580.0;
const _albumHeight = 56.0;
const _minSwipe = 24.0;

String birdArt(int level) => 'assets/birds/$level.png';

Iterable<String> allBirdArt() => [
  for (var level = 1; level <= maxLevel; level++) birdArt(level),
];

String birdName(AppLocalizations l10n, int level) => switch (level) {
  1 => l10n.bird1,
  2 => l10n.bird2,
  3 => l10n.bird3,
  4 => l10n.bird4,
  5 => l10n.bird5,
  6 => l10n.bird6,
  7 => l10n.bird7,
  8 => l10n.bird8,
  9 => l10n.bird9,
  10 => l10n.bird10,
  _ => l10n.bird11,
};

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
        final room = box.maxHeight - 24 - (album ? _albumHeight + 8 : 0);
        final side = min(_maxSide, min(box.maxWidth - 24, room));
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Nest(game: game, side: max(side, 80)),
            if (album) ...[
              const SizedBox(height: 8),
              _Album(unlocked: game.unlocked),
            ],
          ],
        );
      },
    ),
  );
}

class _Nest extends StatefulWidget {
  const _Nest({required this.game, required this.side});

  final GameController game;
  final double side;

  @override
  State<_Nest> createState() => _NestState();
}

class _NestState extends State<_Nest> {
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
    final l10n = AppLocalizations.of(context);
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
        duration: _slideTime,
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
                positioned(ghost, _Fading(child: _Art(ghost.level))),
              for (final tile in state.tiles)
                positioned(
                  tile,
                  _Hatch(key: ValueKey(tile.level), child: _Art(tile.level)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Art extends StatelessWidget {
  const _Art(this.level);

  final int level;

  @override
  Widget build(BuildContext context) => Image.asset(
    birdArt(level),
    fit: BoxFit.fill,
    filterQuality: FilterQuality.medium,
    gaplessPlayback: true,
  );
}

/// Grows in when an egg is laid or a bird changes.
class _Hatch extends StatelessWidget {
  const _Hatch({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: .55, end: 1),
    duration: const Duration(milliseconds: 190),
    curve: Curves.easeOutBack,
    builder: (context, scale, content) =>
        Transform.scale(scale: scale, child: content),
    child: child,
  );
}

/// What a merged tile leaves behind, gone once it arrives.
class _Fading extends StatelessWidget {
  const _Fading({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 1, end: 0),
    duration: _slideTime,
    curve: const Interval(.7, 1),
    builder: (context, opacity, content) =>
        Opacity(opacity: opacity, child: content),
    child: child,
  );
}

/// The whole chain of birds. The ones not raised yet are only shadows.
class _Album extends StatelessWidget {
  const _Album({required this.unlocked});

  final int unlocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      height: _albumHeight,
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
                    dimension: _albumHeight,
                    child: level <= unlocked
                        ? _Art(level)
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
