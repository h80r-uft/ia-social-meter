import 'dart:io';

import 'dataset/student.dart';
import 'neural_network/network.dart';

void main(List<String> args) {
  final dataset = _getMappedDataset();
  final trainingDataLenght = (dataset.length * 0.7).toInt();
  final trainingData = dataset.take(trainingDataLenght).toList();
  final testData = dataset.skip(trainingDataLenght).toList();

  final network = Network(
    trainingData: trainingData,
    learningRate: 0.5,
    maxEpoch: 10000,
    isOptimized: true,
  );

  print('Iniciando treinamento');
  print('Mean Squared Error: ${network.train()}');

  // final network = Network.fromFile('./network_data.h8');

  for (int i = 0; i < testData.length; i++) {
    final currentTest = testData[i]['input'] ?? [];
    print('Entrada = $currentTest');
    print('Saida = ${network.predict(currentTest)}\n');
    print('Saída esperada = ${testData[i]['output']}');
  }

  // ask the user to save or not the network
  stdout.write('Deseja salvar a rede? (s/N) ');
  final answer = stdin.readLineSync();
  if (answer == 's') {
    network.saveTraining('./network_data');
  }
}

List<Map<String, List<double>>> _getMappedDataset() {
  final rawData = File('./dataset/student-mat.csv').readAsLinesSync()
    ..removeAt(0);

  final students = rawData.map((line) => Student(line)).toList();

  return students.map((e) => {'input': e.inputs, 'output': e.outputs}).toList();
}
