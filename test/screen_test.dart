import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psito_games_ui/psito_games_ui.dart';
import 'package:psito_nest/l10n/app_localizations.dart';
import 'package:psito_nest/src/game/game_state.dart';
import 'package:psito_nest/src/game/scores.dart';
import 'package:psito_nest/src/ui/organisms/board.dart';
import 'package:psito_nest/src/ui/pages/game_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpGame(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(
      locale: Locale('pt'),
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        GamesUiLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: GameScreen(number: 3),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> finish(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the arrows slide the nest', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([0, 0, 0, 1, ...List.filled(12, 0)]);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.state.grid[0], 1);
    await finish(tester);
  });

  testWidgets('dragging across the nest slides it', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([0, 0, 0, 1, ...List.filled(12, 0)]);
    final center = tester.getCenter(find.byType(Board));
    await tester.dragFrom(center, const Offset(-120, 0));
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.state.grid[0], 1);
    await finish(tester);
  });

  testWidgets('a short drag does not slide', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([0, 0, 0, 1, ...List.filled(12, 0)]);
    final center = tester.getCenter(find.byType(Board));
    await tester.dragFrom(center, const Offset(-10, 0), touchSlopX: 0);
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.state.grid[3], 1);
    await finish(tester);
  });

  testWidgets('undo is available after a slide', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([0, 0, 0, 1, ...List.filled(12, 0)]);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byIcon(Icons.undo_rounded));
    await tester.pump(const Duration(milliseconds: 400));
    expect(game.state.grid[3], 1);
    expect(game.canUndo, isFalse);
    await finish(tester);
  });

  testWidgets('the queen ends the game and the name is saved', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([
      maxLevel - 1,
      maxLevel - 1,
      ...List.filled(14, 0),
    ]);
    game.slide(Direction.left);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('A rainha nasceu!'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Ana');
    await tester.pump();
    await tester.tap(find.text('Salvar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Ana'), findsOneWidget);
    final saved = await const ScoreStore().load();
    expect(saved.single.level, maxLevel);
    await finish(tester);
  });

  testWidgets('a full nest ends the game', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([
      0, 7, 8, 7, //
      8, 7, 8, 9,
      7, 8, 7, 8,
      8, 7, 8, 7,
    ]);
    // The only free place is left next to birds no new egg can join.
    game.slide(Direction.left);
    await tester.pump(const Duration(seconds: 1));
    expect(game.state.isStuck, isTrue);
    expect(find.text('O ninho encheu!'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('progress comes back from the saved games', (tester) async {
    SharedPreferences.setMockInitialValues({'best': 900, 'unlocked': 6});
    await pumpGame(tester, const Size(1280, 800));
    await tester.pump();
    expect(find.text('900'), findsOneWidget);
    await finish(tester);
  });

  testWidgets('every slide of the nest has a name for screen readers', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpGame(tester, const Size(1280, 800));
    expect(find.bySemanticsLabel(RegExp('^Ninho')), findsOneWidget);
    handle.dispose();
    await finish(tester);
  });

  testWidgets('fits small and large windows without overflowing', (
    tester,
  ) async {
    for (final size in const [
      Size(480, 360),
      Size(1920, 1080),
      Size(800, 1200),
      Size(480, 300),
      // Phones, standing and lying, and a tablet.
      Size(360, 740),
      Size(320, 568),
      Size(740, 360),
      Size(1280, 800),
      Size(800, 1280),
    ]) {
      await pumpGame(tester, size);
      expect(tester.takeException(), isNull, reason: '$size');
    }
    await finish(tester);
  });

  testWidgets('a game left halfway comes back', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await const ScoreStore().saveGame(
      SavedGame(number: 42, score: 36, grid: [3, 2, ...List.filled(14, 0)]),
    );
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('pt'),
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          GamesUiLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: GameScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
    final game = tester.widget<Board>(find.byType(Board)).game;
    expect(game.number, 42);
    expect(game.state.grid.take(2), [3, 2]);
    expect(find.text('36'), findsWidgets);

    game.slide(Direction.right);
    await tester.pump(const Duration(milliseconds: 300));
    final kept = await const ScoreStore().loadGame();
    expect(kept!.grid, game.state.grid);
    await finish(tester);
  });

  testWidgets('a game that ended is not kept', (tester) async {
    await pumpGame(tester, const Size(1280, 800));
    final game = tester.widget<Board>(find.byType(Board)).game;
    game.state = GameState.fromGrid([
      maxLevel - 1,
      maxLevel - 1,
      ...List.filled(14, 0),
    ]);
    game.slide(Direction.left);
    await tester.pump(const Duration(seconds: 1));
    expect(await const ScoreStore().loadGame(), isNull);
    await finish(tester);
  });
}
