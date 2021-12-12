import 'dart:math';

import 'math.dart';

class Neuron {
  Neuron(int weightsCount)
      : learningRate = 0.1,
        inputs = [],
        weights = List.generate(
          weightsCount,
          (index) => _random.nextDouble() * 2 - 1,
        );

  static final _random = Random();

  double learningRate;
  List<double> inputs;
  List<double> weights;

  double evaluate() {
    var index = 0;
    final sum = inputs.fold<double>(
      0.0,
      (result, e) => result + e * weights[index++],
    );

    return tanh(sum);
  }

  void train(double error) {
    final delta = (1 - pow(evaluate(), 2)) * error;

    for (var i = 0; i < weights.length; i++) {
      weights[i] += learningRate * delta * inputs[i];
    }
  }
}
