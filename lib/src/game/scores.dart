import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_state.dart';

/// A finished game.
@immutable
class Score {
  const Score({
    required this.name,
    required this.points,
    required this.level,
    required this.game,
  });

  factory Score.fromJson(Map<String, dynamic> json) => Score(
    name: json['name'] as String,
    points: json['points'] as int,
    level: json['level'] as int,
    game: json['game'] as int,
  );

  final String name;
  final int points;

  /// The rarest bird of that game.
  final int level;
  final int game;

  Map<String, dynamic> toJson() => {
    'name': name,
    'points': points,
    'level': level,
    'game': game,
  };
}

const maxScores = 10;

/// The list with [score] in its place, keeping only the best ones.
List<Score> insertScore(List<Score> scores, Score score) {
  final sorted = [...scores, score]
    ..sort((a, b) => b.points.compareTo(a.points));
  return sorted.take(maxScores).toList();
}

/// A game left halfway: on a phone the system may close the program at any
/// time, and the nest must be there when the player comes back.
@immutable
class SavedGame {
  const SavedGame({
    required this.number,
    required this.score,
    required this.grid,
  });

  factory SavedGame.fromJson(Map<String, dynamic> json) => SavedGame(
    number: json['number'] as int,
    score: json['score'] as int,
    grid: [for (final level in json['grid'] as List) level as int],
  );

  final int number;
  final int score;

  /// The levels, cell by cell, with 0 for an empty place.
  final List<int> grid;

  Map<String, dynamic> toJson() => {
    'number': number,
    'score': score,
    'grid': grid,
  };
}

/// The scores, the last name used, the progress of the album and the game
/// in progress. They stay on this device.
class ScoreStore {
  const ScoreStore();

  static const _scoresKey = 'scores';
  static const _nameKey = 'player_name';
  static const _bestKey = 'best';
  static const _unlockedKey = 'unlocked';
  static const _gameKey = 'game';

  Future<List<Score>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_scoresKey);
    if (raw == null) return const [];
    try {
      return [
        for (final item in jsonDecode(raw) as List)
          Score.fromJson(item as Map<String, dynamic>),
      ];
    } on Object {
      // A damaged file must not stop the game.
      return const [];
    }
  }

  Future<void> save(List<Score> scores) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_scoresKey, jsonEncode(scores));
  }

  Future<String> lastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? '';
  }

  Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
  }

  Future<(int best, int unlocked)> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getInt(_bestKey) ?? 0, prefs.getInt(_unlockedKey) ?? 0);
  }

  Future<void> saveProgress({required int best, required int unlocked}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bestKey, best);
    await prefs.setInt(_unlockedKey, unlocked);
  }

  /// The game left halfway, if there is one.
  Future<SavedGame?> loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_gameKey);
    if (raw == null) return null;
    try {
      final game = SavedGame.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      if (game.grid.length != cellCount) return null;
      return game;
    } on Object {
      // A damaged file must not stop the game.
      return null;
    }
  }

  /// Keeps [game], or forgets the one kept when it is null.
  Future<void> saveGame(SavedGame? game) async {
    final prefs = await SharedPreferences.getInstance();
    if (game == null) {
      await prefs.remove(_gameKey);
    } else {
      await prefs.setString(_gameKey, jsonEncode(game));
    }
  }
}
