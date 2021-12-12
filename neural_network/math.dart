import 'dart:math';

double tanh(double x) {
  return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}

void main() {
  print(tanh(0.5));
}
