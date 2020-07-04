void main() {
  String test = 'p4';
  print(test.substring(0, 1) +
      (double.parse(test.substring(1)) + 1).toStringAsFixed(0));
}
