import 'dart:math';

import 'network.dart';

void main(List<String> args) {
  final inputs = [
    [-1.0, -1.0],
    [1.0, -1.0],
    [-1.0, 1.0],
    [1.0, 1.0],
  ];

  final outputs = [
    [-1.0],
    [1.0],
    [1.0],
    [-1.0],
  ];

  final trainingData = [
    {
      'input': [-1.0, -1.0],
      'output': [-1.0]
    },
    {
      'input': [-1.0, 1.0],
      'output': [1.0]
    },
    {
      'input': [1.0, -1.0],
      'output': [1.0]
    },
    {
      'input': [1.0, 1.0],
      'output': [-1.0]
    },
  ];

  final network = Network(
    trainingData: trainingData,
    learningRate: 0.5,
  );

  double? meanSquaredError;
  final epochMax = 1000;

  for (var epoch = 0; epoch < epochMax; epoch++) {
    var inputIndex = 0;
    meanSquaredError = inputs.fold<double>(0.0, (finalSum, input) {
          network.feedForward(input);

          var outputIndex = 0;
          final result = outputs[inputIndex++].fold<double>(0.0, (sum, output) {
            return sum +
                pow(
                  (output - network.evaluate(outputIndex++)),
                  2,
                );
          });

          network.backPropagate(outputs[inputIndex - 1]);

          return finalSum + result;
        }) /
        inputs.length;

    if (meanSquaredError > 1 && epoch > epochMax / 5) {
      network.restart();
      epoch = 0;
    }
  }

  print('Mean Squared Error: $meanSquaredError');

  for (int i = 0; i < inputs.length; i++) {
    for (int j = 0; j < inputs.first.length; j++) {
      print("Entrada[$j] = ${inputs[i][j]}");
    }

    network.feedForward(inputs[i]);

    for (int j = 0; j < outputs.first.length; j++) {
      print("Saida[$j] = ${network.evaluate(j)}");
    }

    print("\n");
  }
}
