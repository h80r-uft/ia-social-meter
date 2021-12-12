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
    maxEpoch: 1000,
  );

  print('Main Squared Error: ${network.train()}');

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
