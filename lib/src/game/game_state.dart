import 'dart:math';

import 'package:flutter/foundation.dart';

enum Direction { up, down, left, right }

const boardSize = 4;
const cellCount = boardSize * boardSize;

/// The last bird of the chain: reaching it wins the game.
const maxLevel = 11;

/// One egg or bird in the nest. It keeps its [id] while it moves, so that the
/// screen can follow it.
@immutable
class Tile {
  const Tile({required this.id, required this.level, required this.cell});

  final int id;
  final int level;
  final int cell;
}

/// The nest. Immutable: each slide gives a new one.
@immutable
class GameState {
  const GameState({
    this.tiles = const [],
    this.ghosts = const [],
    this.score = 0,
    this.nextId = 1,
  });

  /// A nest from its [levels], cell by cell, with 0 for an empty place.
  factory GameState.fromGrid(List<int> levels, {int score = 0}) {
    final tiles = [
      for (var cell = 0; cell < levels.length; cell++)
        if (levels[cell] != 0)
          Tile(id: cell + 1, level: levels[cell], cell: cell),
    ];
    return GameState(tiles: tiles, score: score, nextId: levels.length + 1);
  }

  /// A nest with its first two eggs.
  factory GameState.start(Random random) =>
      const GameState().spawn(random).spawn(random);

  final List<Tile> tiles;

  /// The tiles absorbed by the last slide. They travel to where they merged
  /// and fade away.
  final List<Tile> ghosts;
  final int score;
  final int nextId;

  /// The points that making a bird of [level] gives.
  static int value(int level) => 1 << level;

  int get highest => tiles.isEmpty ? 0 : tiles.map((t) => t.level).reduce(max);
  bool get isWon => highest >= maxLevel;
  bool get isStuck => freeCells.isEmpty && !_canMerge;
  bool get isOver => isWon || isStuck;

  /// The grid as a list of levels, with 0 for an empty place.
  List<int> get grid {
    final levels = List.filled(cellCount, 0);
    for (final tile in tiles) {
      levels[tile.cell] = tile.level;
    }
    return levels;
  }

  List<int> get freeCells {
    final levels = grid;
    return [
      for (var cell = 0; cell < cellCount; cell++)
        if (levels[cell] == 0) cell,
    ];
  }

  bool get _canMerge {
    final levels = grid;
    for (var cell = 0; cell < cellCount; cell++) {
      final level = levels[cell];
      if (level == 0 || level >= maxLevel) continue;
      final right = cell % boardSize < boardSize - 1;
      if (right && levels[cell + 1] == level) return true;
      if (cell + boardSize < cellCount && levels[cell + boardSize] == level) {
        return true;
      }
    }
    return false;
  }

  GameState get withoutGhosts =>
      GameState(tiles: tiles, score: score, nextId: nextId);

  /// The cells of each line, starting from the wall the tiles go to.
  static Iterable<List<int>> _lines(Direction direction) sync* {
    for (var a = 0; a < boardSize; a++) {
      final line = [
        for (var b = 0; b < boardSize; b++)
          switch (direction) {
            Direction.left => a * boardSize + b,
            Direction.right => a * boardSize + boardSize - 1 - b,
            Direction.up => b * boardSize + a,
            Direction.down => (boardSize - 1 - b) * boardSize + a,
          },
      ];
      yield line;
    }
  }

  /// Slides everything to one side, joining equal neighbours once.
  /// Null when nothing would move.
  GameState? slide(Direction direction) {
    final byCell = {for (final tile in tiles) tile.cell: tile};
    final moved = <Tile>[];
    final ghosts = <Tile>[];
    var points = 0;
    var changed = false;
    for (final line in _lines(direction)) {
      final placed = <Tile>[];
      var canJoin = false;
      for (final cell in line) {
        final tile = byCell[cell];
        if (tile == null) continue;
        final last = placed.isEmpty ? null : placed.last;
        if (last != null &&
            canJoin &&
            last.level == tile.level &&
            tile.level < maxLevel) {
          final level = tile.level + 1;
          placed.last = Tile(id: last.id, level: level, cell: last.cell);
          ghosts.add(Tile(id: tile.id, level: tile.level, cell: last.cell));
          points += value(level);
          canJoin = false;
          changed = true;
        } else {
          final target = line[placed.length];
          if (target != cell) changed = true;
          placed.add(Tile(id: tile.id, level: tile.level, cell: target));
          canJoin = true;
        }
      }
      moved.addAll(placed);
    }
    if (!changed) return null;
    return GameState(
      tiles: moved,
      ghosts: ghosts,
      score: score + points,
      nextId: nextId,
    );
  }

  /// Lays a new egg on a free place; one in ten is already hatching.
  GameState spawn(Random random) {
    final free = freeCells;
    if (free.isEmpty) return this;
    final tile = Tile(
      id: nextId,
      level: random.nextInt(10) == 0 ? 2 : 1,
      cell: free[random.nextInt(free.length)],
    );
    return GameState(
      tiles: [...tiles, tile],
      ghosts: ghosts,
      score: score,
      nextId: nextId + 1,
    );
  }
}
