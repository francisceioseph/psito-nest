import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psito_nest/src/game/game_controller.dart';
import 'package:psito_nest/src/game/game_state.dart';
import 'package:psito_nest/src/game/scores.dart';
import 'package:shared_preferences/shared_preferences.dart';

GameState nest(List<int> levels, {int score = 0}) =>
    GameState.fromGrid(levels, score: score);

/// A nest with [row] as its first line and the rest empty.
GameState line(List<int> row) => nest([...row, ...List.filled(12, 0)]);

void main() {
  group('slide', () {
    test('goes to the wall, leaving no holes', () {
      expect(line([0, 1, 0, 2]).slide(Direction.left)!.grid.take(4), [1, 2, 0, 0]);
      expect(line([1, 0, 2, 0]).slide(Direction.right)!.grid.take(4), [0, 0, 1, 2]);
    });

    test('works up and down', () {
      final state = nest([0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0]);
      expect(state.slide(Direction.up)!.grid[0], 4);
      expect(state.slide(Direction.down)!.grid[12], 4);
    });

    test('equal neighbours join and give points', () {
      final state = line([2, 2, 0, 0]).slide(Direction.left)!;
      expect(state.grid.take(4), [3, 0, 0, 0]);
      expect(state.score, GameState.value(3));
      expect(state.ghosts.single.cell, 0);
    });

    test('each tile joins only once per slide', () {
      expect(line([1, 1, 2, 0]).slide(Direction.left)!.grid.take(4), [2, 2, 0, 0]);
      expect(line([1, 1, 1, 1]).slide(Direction.left)!.grid.take(4), [2, 2, 0, 0]);
    });

    test('the ones nearest the wall join first', () {
      expect(line([1, 1, 1, 0]).slide(Direction.left)!.grid.take(4), [2, 1, 0, 0]);
      expect(line([1, 1, 1, 0]).slide(Direction.right)!.grid.take(4), [0, 0, 1, 2]);
    });

    test('tiles apart with a hole between still join', () {
      expect(line([1, 0, 0, 1]).slide(Direction.left)!.grid.take(4), [2, 0, 0, 0]);
    });

    test('nothing moving means no slide', () {
      expect(line([1, 2, 3, 4]).slide(Direction.left), isNull);
      expect(line([1, 2, 3, 4]).slide(Direction.up), isNull);
    });

    test('a tile that stays keeps its id', () {
      final before = line([5, 0, 0, 0]);
      final after = before.slide(Direction.right)!;
      expect(after.tiles.single.id, before.tiles.single.id);
    });

    test('queens do not join', () {
      expect(
        line([maxLevel, maxLevel, 0, 0]).slide(Direction.left),
        isNull,
      );
    });
  });

  group('eggs', () {
    test('a game starts with two', () {
      final state = GameState.start(Random(1));
      expect(state.tiles.length, 2);
      expect(state.tiles.every((t) => t.level <= 2), isTrue);
    });

    test('are laid on free places with new ids', () {
      final full = nest([...List.filled(15, 1), 0]);
      final next = full.spawn(Random(3));
      expect(next.tiles.last.cell, 15);
      expect(next.tiles.map((t) => t.id).toSet().length, 16);
      expect(next.spawn(Random(3)), same(next));
    });

    test('the same number gives the same game', () {
      List<int> play(int number) {
        final game = GameController(number: number);
        for (final direction in Direction.values) {
          game.slide(direction);
        }
        return game.state.grid;
      }

      expect(play(7), play(7));
    });
  });

  group('end of the game', () {
    final stuck = nest([1, 2, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 1]);

    test('a full nest with nothing to join is over', () {
      expect(stuck.isStuck, isTrue);
      expect(stuck.isOver, isTrue);
      expect(stuck.isWon, isFalse);
    });

    test('a full nest with a pair still goes on', () {
      expect(nest([1, 1, 1, 2, 2, 1, 2, 1, 1, 2, 1, 2, 2, 1, 2, 1]).isStuck, isFalse);
    });

    test('the queen wins', () {
      final state = line([maxLevel - 1, maxLevel - 1, 0, 0]).slide(Direction.left)!;
      expect(state.isWon, isTrue);
    });
  });

  group('controller', () {
    test('a slide lays one egg and raises the best', () {
      final game = GameController(number: 3);
      game.state = line([2, 2, 0, 0]);
      game.slide(Direction.left);
      expect(game.state.tiles.length, 2);
      expect(game.best, GameState.value(3));
      expect(game.unlocked, 3);
    });

    test('a slide that moves nothing lays no egg', () {
      final game = GameController(number: 3);
      game.state = line([1, 2, 3, 4]);
      game.slide(Direction.left);
      expect(game.state.tiles.length, 4);
      expect(game.canUndo, isFalse);
    });

    test('undo takes back only the last slide, and the score', () {
      final game = GameController(number: 3);
      game.state = line([2, 2, 0, 0]);
      game.slide(Direction.left);
      game.undo();
      expect(game.state.grid.take(4), [2, 2, 0, 0]);
      expect(game.state.score, 0);
      expect(game.state.ghosts, isEmpty);
      expect(game.canUndo, isFalse);
    });

    test('progress from saved games never lowers what was reached', () {
      final game = GameController(number: 3);
      game.restoreProgress(best: 500, unlocked: 7);
      game.restoreProgress(best: 10, unlocked: 2);
      expect(game.best, 500);
      expect(game.unlocked, 7);
    });
  });

  group('scores', () {
    Score score(String name, int points) =>
        Score(name: name, points: points, level: 5, game: 1);

    test('the highest come first and only the ten best stay', () {
      var scores = <Score>[];
      for (var i = 0; i < 12; i++) {
        scores = insertScore(scores, score('$i', i));
      }
      expect(scores.length, maxScores);
      expect(scores.first.name, '11');
      expect(scores.last.name, '2');
    });

    test('survive saving and a damaged file is ignored', () async {
      SharedPreferences.setMockInitialValues({});
      const store = ScoreStore();
      await store.save([score('Ana', 90)]);
      expect((await store.load()).single.level, 5);

      SharedPreferences.setMockInitialValues({'scores': 'not json'});
      expect(await store.load(), isEmpty);
    });

    test('the progress is kept', () async {
      SharedPreferences.setMockInitialValues({});
      const store = ScoreStore();
      expect(await store.loadProgress(), (0, 0));
      await store.saveProgress(best: 40, unlocked: 6);
      expect(await store.loadProgress(), (40, 6));
    });
  });
}
