import 'dart:math';

import 'math.dart';

/// Neuron creates a neuron with [weightsCount] weights, randomly generated
/// between -1 and 1.
class Neuron {
  Neuron({
    required int weightsCount,
    required this.learningRate,
  })  : inputs = [],
        weights = List.generate(
          weightsCount,
          (index) => _random.nextDouble() * 2 - 1,
        );

  /// The pseudo-random number generator used to generate weights.
  static final _random = Random();

  /// The learning rate of the neuron.
  final double learningRate;

  /// The inputs to the neuron.
  List<double> inputs;

  /// The weights of the neuron.
  final List<double> weights;

  /// Returns the output of the neuron.
  double evaluate() {
    var index = 0;
    final sum = inputs.fold<double>(
      0.0,
      (result, e) => result + e * weights[index++],
    );

    return tanh(sum);
  }

  /// Updates the weights of the neuron.
  void train(double error) {
    final delta = (1 - pow(evaluate(), 2)) * error;

    for (var i = 0; i < weights.length; i++) {
      weights[i] += learningRate * delta * inputs[i];
    }
  }
}
