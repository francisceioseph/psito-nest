import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/game_controller.dart';
import '../game/game_state.dart';
import '../game/scores.dart';
import 'app_bar.dart';
import 'board.dart';
import 'colors.dart';
import 'peek.dart';
import 'victory_panel.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.number});

  /// A fixed game number. Without one, the eggs come at random.
  final int? number;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _idle = Duration(seconds: 45);
  static const _peekTime = Duration(milliseconds: 3200);

  late final GameController _game = GameController(number: widget.number);
  final _store = const ScoreStore();
  Timer? _timer;
  final _random = Random();
  PeekSpot? _spot;
  bool _peeking = false;
  bool _precached = false;
  bool _wasOver = false;
  int _savedBest = 0;
  int _savedUnlocked = 0;

  @override
  void initState() {
    super.initState();
    _waitIdle();
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
    if (over && !_wasOver) _peek();
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
    _timer?.cancel();
    _game.dispose();
    super.dispose();
  }

  void _waitIdle() {
    _timer?.cancel();
    _timer = Timer(_idle, _peek);
  }

  void _peek() {
    _timer?.cancel();
    setState(() {
      _spot = nextPeekSpot(_random, _spot);
      _peeking = true;
    });
    _timer = Timer(_peekTime, () {
      setState(() => _peeking = false);
      _waitIdle();
    });
  }

  void _activity() {
    if (_peeking) setState(() => _peeking = false);
    _waitIdle();
  }

  void _slide(Direction direction) {
    _activity();
    _game.slide(direction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PsitoColors.felt,
      body: CallbackShortcuts(
        bindings: {
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
        child: Focus(
          autofocus: true,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _activity(),
            child: Column(
              children: [
                ListenableBuilder(
                  listenable: _game,
                  builder: (context, _) => GameAppBar(game: _game),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 1.1,
                            colors: [
                              PsitoColors.feltGlow,
                              PsitoColors.felt,
                              PsitoColors.feltDark,
                            ],
                            stops: [0, .6, 1],
                          ),
                        ),
                      ),
                      Board(game: _game),
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
                      if (_spot case final spot?)
                        Peek(
                          key: ObjectKey(spot),
                          spot: spot,
                          visible: _peeking,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
