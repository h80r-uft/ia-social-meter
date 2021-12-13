import 'dart:convert';
import 'dart:io';

import 'dataset/normalizer.dart';
import 'neural_network/network.dart';

void main(List<String> args) {
  print('Choose:\n[1] Train a model\n[2] Load a model');
  final isLoaded = int.tryParse(stdin.readLineSync() ?? '') == 2;

  File? modelFile;
  if (isLoaded) {
    while (modelFile == null) {
      print('Enter the path to the model:');
      final path = stdin.readLineSync() ?? '';
      modelFile = File(path);
      modelFile.existsSync() ? print('Model found') : modelFile = null;
    }
  }

  final network = isLoaded ? Network.fromFile(modelFile!.path) : trainModel();

  while (true) {
    print('Do you wish to test the model? [y/N]');
    final test = stdin.readLineSync()?.toLowerCase().startsWith('y') ?? false;

    if (!test) break;

    print('Enter your Waifu\'s name:');
    final name = stdin.readLineSync() ?? '';
    print('Enter your Waifu\'s age:');
    var age = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
    print('Enter your Waifu\'s height:');
    var height = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
    print('Enter your Waifu\'s weight:');
    var weight = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
    print('Enter your Waifu\'s bust size:');
    var bust = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
    print('Enter your Waifu\'s waist size:');
    var waist = double.tryParse(stdin.readLineSync() ?? '') ?? 0;
    print('Enter your Waifu\'s hip size:');
    var hip = double.tryParse(stdin.readLineSync() ?? '') ?? 0;

    final waifu = {
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'bust': bust,
      'waist': waist,
      'hip': hip,
    };

    normalizer(waifu);

    age = waifu['age'] as double;
    height = waifu['height'] as double;
    weight = waifu['weight'] as double;
    bust = waifu['bust'] as double;
    waist = waifu['waist'] as double;
    hip = waifu['hip'] as double;

    final results = denormalize(
      network.predict([age, height, weight, bust, waist, hip]),
    ).map((e) => e.round());

    print('$name:');
    print('\tLikes: ${results.first}');
    print('\tTrash: ${results.last}');
  }

  if (!isLoaded) {
    print('Do you wish to save this model? [y/N]');
    final save = stdin.readLineSync()?.toLowerCase().startsWith('y') ?? false;

    if (save) {
      print('Enter the path to save the model:');
      final path = stdin.readLineSync() ?? '';
      network.saveTraining(path);
    }
  }
}

Network trainModel() {
  final data = (jsonDecode(
    File(
      './dataset/waifus_normalized.json',
    ).readAsStringSync(),
  ) as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();

  final trainingData = data.map((e) {
    final input = [
      e['age'] as double,
      e['height'] as double,
      e['weight'] as double,
      e['bust'] as double,
      e['waist'] as double,
      e['hip'] as double,
    ];

    final output = [
      e['likes'] as double,
      e['trash'] as double,
    ];

    return {'input': input, 'output': output};
  }).toList();

  final network = Network(
    trainingData: trainingData,
    learningRate: 0.5,
    maxEpoch: 10000,
    isOptimized: true,
  );

  print(network.train());

  return network;
}
