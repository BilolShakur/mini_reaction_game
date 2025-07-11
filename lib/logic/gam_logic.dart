import 'dart:math';
import 'dart:ui';

class GameLogic {
  Random random = Random();

  Offset changeOffset(double screenheigh, double screenWidth) {
    return Offset(
      random.nextDouble() * (screenWidth - 100),
      random.nextDouble() * (screenheigh - 300),
    );
  }
}
