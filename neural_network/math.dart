import 'dart:math';

/// Calculates the hyperbolic tangent of an angle given in radians.
double tanh(double x) {
  return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}

void main() {
  print(tanh(0.5));
}
