import 'dart:math';

import 'package:flutter/foundation.dart';

import 'game_state.dart';

/// A game in progress, and what the player has reached so far.
class GameController extends ChangeNotifier {
  GameController({int? number}) : number = number ?? _randomNumber() {
    _random = Random(this.number);
    state = GameState.start(_random);
    unlocked = state.highest;
  }

  static int _randomNumber() => Random().nextInt(999999) + 1;

  int number;
  late Random _random;
  late GameState state;

  /// Changes with each new game, so that nothing carries over to the next.
  int gameId = 0;

  /// The best score ever made.
  int best = 0;

  /// The rarest bird ever raised, which opens the album up to it.
  late int unlocked;

  GameState? _previous;

  bool get canUndo => _previous != null;

  void newGame() {
    number = _randomNumber();
    _random = Random(number);
    state = GameState.start(_random);
    _previous = null;
    gameId++;
    notifyListeners();
  }

  /// Puts back what the saved games have reached.
  void restoreProgress({required int best, required int unlocked}) {
    this.best = max(this.best, best);
    this.unlocked = max(this.unlocked, unlocked);
    notifyListeners();
  }

  /// Slides the nest. Only the last slide can be undone.
  void slide(Direction direction) {
    if (state.isOver) return;
    final moved = state.slide(direction);
    if (moved == null) return;
    _previous = state.withoutGhosts;
    state = moved.spawn(_random);
    best = max(best, state.score);
    unlocked = max(unlocked, state.highest);
    notifyListeners();
  }

  void undo() {
    final previous = _previous;
    if (previous == null || state.isOver) return;
    state = previous;
    _previous = null;
    notifyListeners();
  }
}
