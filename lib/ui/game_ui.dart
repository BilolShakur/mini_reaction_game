import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reaction_game/extensions/average_on_list.dart';
import 'package:reaction_game/logic/gam_logic.dart';
import 'package:reaction_game/ui/widgets/circle_button.dart';

class GameUi extends StatefulWidget {
  const GameUi({super.key});

  @override
  State<GameUi> createState() => _GameUiState();
}

class _GameUiState extends State<GameUi> {
  Offset position = const Offset(10, 20);
  bool hide = false;
  Stopwatch stopwatch = Stopwatch();
  Timer? timer;
  double reactionTime = 0.0;
  List<double> reactionTimes = [];
  bool isPaused = false;

  final GameLogic logic = GameLogic();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startStopwatch() {
    stopwatch.reset();
    stopwatch.start();
    timer?.cancel(); // cancel any previous timer
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        reactionTime = stopwatch.elapsedMicroseconds / 1000.0;
      });
    });
  }

  void pauseGame() {
    if (!isPaused) {
      // Pause everything
      stopwatch.stop();
      timer?.cancel();
      setState(() {
        isPaused = true;
      });
    } else {
      stopwatch.start();
      timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
        setState(() {
          reactionTime = stopwatch.elapsedMicroseconds / 1000.0;
        });
      });
      setState(() {
        isPaused = false;
      });
    }
  }

  Future<void> _startNewRound() async {
    hide = true;
    setState(() {});

    await Future.delayed(Duration(milliseconds: 500 + random.nextInt(2000)));

    position = logic.changeOffset(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
    );

    hide = false;
    _startStopwatch();

    setState(() {});
  }

  void _onTap() {
    stopwatch.stop();
    timer?.cancel();

    if (reactionTime != 0) {
      reactionTimes.add(reactionTime);
    }

    reactionTime = 0;
    _startNewRound();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 150,
        backgroundColor: Colors.blueAccent,
        title: Column(
          children: [
            Text("Taps: ${reactionTimes.length}"),

            Text("Average: ${reactionTimes.average.toStringAsFixed(0)} ms"),
            Text("Best: ${reactionTimes.lowest.toStringAsFixed(0)} ms"),
            if (reactionTimes.isNotEmpty)
              Text("Last: ${reactionTimes.last.toStringAsFixed(2)} ms"),

            Text("Current: ${reactionTime.toStringAsFixed(0)} ms"),
          ],
        ),
        leadingWidth: 100,
        leading: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 8),
            IconButton.filledTonal(
              color: Colors.white,
              onPressed: () {
                reactionTimes.clear();
                reactionTime = 0.0;
                setState(() {});
                _startNewRound();
              },
              icon: Icon(Icons.restart_alt, color: Colors.red, size: 40),
            ),
            SizedBox(height: 15),
            IconButton.filledTonal(
              color: Colors.white,
              onPressed: () {
                pauseGame();
              },
              icon: isPaused
                  ? Icon(Icons.play_arrow, color: Colors.red, size: 40)
                  : Icon(Icons.pause, color: Colors.red, size: 40),
            ),
          ],
        ),

        // leading: const Padding(
        //   padding: EdgeInsets.only(top: 25, left: 10),
        //   child: Text(
        //     "Reaction Game",
        //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        //   ),
        // ),
      ),
      body: Stack(
        children: [
          if (!hide)
            Positioned(
              left: position.dx,
              top: position.dy,
              child: GestureDetector(
                onTap: _onTap,
                child: const CircleButton(),
              ),
            ),
        ],
      ),
    );
  }
}
