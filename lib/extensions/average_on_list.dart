extension NumListAverage on List<double> {
  double get average => isEmpty ? 0 : reduce((a, b) => a + b) / length;
}

extension DoubleListlowest on List<double> {
  double get lowest => isEmpty ? 0 : reduce((a, b) => a < b ? a : b);
}
