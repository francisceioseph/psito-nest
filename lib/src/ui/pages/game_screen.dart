import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psito_games_ui/psito_games_ui.dart';

import '../../game/game_controller.dart';
import '../../game/game_state.dart';
import '../../game/scores.dart';
import '../atoms/bird_art.dart';
import '../organisms/board.dart';
import '../organisms/nest_bar.dart';
import '../organisms/victory_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.number});

  /// A fixed game number. Without one, the eggs come at random.
  final int? number;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameController _game = GameController(number: widget.number);
  final _store = const ScoreStore();
  final _peek = PeekController();
  bool _precached = false;
  bool _wasOver = false;
  int _savedBest = 0;
  int _savedUnlocked = 0;

  @override
  void initState() {
    super.initState();
    _game.addListener(_gameChanged);
    _store.loadProgress().then((progress) {
      if (!mounted) return;
      _savedBest = progress.$1;
      _savedUnlocked = progress.$2;
      _game.restoreProgress(best: progress.$1, unlocked: progress.$2);
    });
  }

  void _gameChanged() {
    final over = _game.state.isOver;
    if (over && !_wasOver) _peek.peekNow();
    _wasOver = over;
    if (_game.best > _savedBest || _game.unlocked > _savedUnlocked) {
      _savedBest = _game.best;
      _savedUnlocked = _game.unlocked;
      _store.saveProgress(best: _savedBest, unlocked: _savedUnlocked);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    for (final path in allBirdArt()) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  void dispose() {
    _game.dispose();
    _peek.dispose();
    super.dispose();
  }

  /// A key is also activity: the cockatiel goes away.
  void _slide(Direction direction) {
    _peek.activity();
    _game.slide(direction);
  }

  @override
  Widget build(BuildContext context) => GameTable(
    peek: _peek,
    shortcuts: {
      const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
          _slide(Direction.up),
      const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
          _slide(Direction.down),
      const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
          _slide(Direction.left),
      const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
          _slide(Direction.right),
      const SingleActivator(LogicalKeyboardKey.keyZ, control: true):
          _game.undo,
      const SingleActivator(LogicalKeyboardKey.keyN, control: true):
          _game.newGame,
    },
    bar: ListenableBuilder(
      listenable: _game,
      builder: (context, _) => NestBar(game: _game),
    ),
    board: Board(game: _game),
    overlays: [
      ListenableBuilder(
        listenable: _game,
        builder: (context, _) => _game.state.isOver
            ? Center(
                child: VictoryPanel(
                  key: ValueKey(_game.gameId),
                  game: _game,
                  store: _store,
                ),
              )
            : const SizedBox.shrink(),
      ),
    ],
  );
}
