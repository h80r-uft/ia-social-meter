import 'network.dart';

void main(List<String> args) {
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

  final inputs = trainingData.map((data) => data['input']!).toList();

  for (int i = 0; i < inputs.length; i++) {
    print("Entrada = ${inputs[i]}");
    print("Saida = ${network.predict(inputs[i])}\n");
  }
}
