import 'package:flutter/material.dart';
import 'package:reaction_game/ui/game_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: GameUi());
  }
}
