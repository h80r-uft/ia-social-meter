import 'dart:math';

import 'neuron.dart';

class Network {
  Network({
    required this.trainingData,
    required double learningRate,
    this.maxEpoch = 10000,
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

  final List<Map<String, List<double>>> trainingData;
  late List<Neuron> hiddenLayer;
  late List<Neuron> outputLayer;
  final int maxEpoch;
  final double bias;

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
    hiddenLayer = hiddenLayer
        .map(
          (e) => Neuron(
            weightsCount: e.weights.length,
            learningRate: e.learningRate,
          ),
        )
        .toList();

    outputLayer = outputLayer
        .map(
          (e) => Neuron(
            weightsCount: e.weights.length,
            learningRate: e.learningRate,
          ),
        )
        .toList();
  }

  double train() {
    var meanSquaredError = 0.0;

    final inputs = trainingData.map((e) => e['input']!).toList();
    final outputs = trainingData.map((e) => e['output']!).toList();

    for (var epoch = 0; epoch < maxEpoch; epoch++) {
      var inputIndex = 0;
      meanSquaredError = inputs.fold<double>(0.0, (finalSum, input) {
            feedForward(input);

            var outputIndex = 0;
            final result =
                outputs[inputIndex++].fold<double>(0.0, (sum, output) {
              return sum +
                  pow(
                    (output - evaluate(outputIndex++)),
                    2,
                  );
            });

            backPropagate(outputs[inputIndex - 1]);

            return finalSum + result;
          }) /
          inputs.length;

      if (epoch > maxEpoch / 5 && meanSquaredError > 1) {
        restart();
        epoch = 0;
      }
    }

    return meanSquaredError;
  }

  List<double> predict(List<double> input) {
    feedForward(input);
    return outputLayer.map((e) => e.evaluate()).toList();
  }
}
