import 'dart:math';

import 'neuron.dart';

class Network {
  Network({
    required List<Map<String, List<double>>> trainingData,
    required double learningRate,
    this.bias = 1.0,
  })  : assert(
          trainingData.isNotEmpty,
          'Training data must not be empty',
        ),
        assert(
          trainingData.first.containsKey('input'),
          'Training data must contain an input layer',
        ),
        assert(
          trainingData.first.containsKey('output'),
          'Training data must contain an output layer',
        ) {
    final inputCount = trainingData.first['input']!.length;
    final hiddenCount = 2 * inputCount + 1;
    final outputCount = trainingData.first['output']!.length;

    hiddenLayer = List.generate(
      hiddenCount,
      (i) => Neuron(
        weightsCount: inputCount + 1,
        learningRate: learningRate,
      ),
    );

    outputLayer = List.generate(
      outputCount,
      (i) => Neuron(
        weightsCount: hiddenCount + 1,
        learningRate: learningRate,
      ),
    );
  }

  late final List<Neuron> hiddenLayer;
  late final List<Neuron> outputLayer;
  late final double bias;

  void setInputs(List<double> inputs) {
    assert(
      inputs.length + 1 == hiddenLayer.first.weights.length,
      'Invalid inputs',
    );

    final newInputs = [bias, ...inputs];

    for (int i = 0; i < hiddenLayer.length; i++) {
      hiddenLayer[i].inputs = newInputs;
    }
  }

  void feedForward(List<double> values) {
    setInputs(values);

    final newInputs = [
      bias,
      ...List.generate(
        hiddenLayer.length,
        (i) => hiddenLayer[i].evaluate(),
      )
    ];

    for (var i = 0; i < outputLayer.length; i++) {
      outputLayer[i].inputs = newInputs;
    }
  }

  void backPropagate(List<double> expected) {
    assert(
      expected.length == outputLayer.length,
      'Invalid expected values',
    );

    final deltas = List.generate(
      outputLayer.length,
      (i) {
        final result = outputLayer[i].evaluate();
        outputLayer[i].train(expected[i] - result);
        return (1 - pow(result, 2)) * (expected[i] - result);
      },
    );

    for (var i = 0; i < hiddenLayer.length; i++) {
      var index = 0;
      final error = outputLayer.fold<double>(
        0.0,
        (sum, neuron) => sum + neuron.weights[i + 1] * deltas[index++],
      );

      hiddenLayer[i].train(error);
    }
  }

  double evaluate(int index) {
    return outputLayer[index].evaluate();
  }

  double winnerTakesAll() {
    return outputLayer.map((e) => e.evaluate()).reduce(max);
  }

  void restart() {
    hiddenLayer.map(
      (e) => Neuron(
        weightsCount: e.weights.length,
        learningRate: e.learningRate,
      ),
    );

    outputLayer.map(
      (e) => Neuron(
        weightsCount: e.weights.length,
        learningRate: e.learningRate,
      ),
    );
  }
}
