import 'dart:io';
import 'dart:math';

import 'network.dart';
import 'neuron.dart';

extension FileSupport on Network {
  void toFile(String path) {
    var result = '';

    final biasLength = bias.toString().length;

    result += '╭─' + ('─' * biasLength) + '─╮\n';
    result += '│ ' + bias.toString() + ' │';
    result += ' ~ Made by h80r [${DateTime.now()}]\n';
    result += '╰─' + ('─' * biasLength) + '─╯\n';

    result += neuronsToString() + '\n';

    result += '«««««««««««««««»»»»»»»»»»»»»»»\n';

    final pathWithExtension = path.endsWith('.h8') ? path : '$path.h8';

    final file = File(pathWithExtension)..createSync(recursive: true);
    file.writeAsStringSync(result, mode: FileMode.write);
  }

  String neuronsToString() {
    var hiddenResult = <String>[];

    final mapHidden = hiddenLayer
        .map((e) => e.weights.map((w) => w.toString()).toList())
        .toList();

    for (final neuron in mapHidden) {
      final neuronLength = neuron.fold<int>(0, (a, b) => max(a, b.length));

      hiddenResult.add('╔═' + ('═' * neuronLength) + '═╗\n');

      for (final weight in neuron) {
        hiddenResult.add(
          '║ ' + weight + (' ' * (neuronLength - weight.length)) + ' ║\n',
        );
      }

      hiddenResult.add('╚═' + ('═' * neuronLength) + '═╝\n');
    }

    final biggestLine = hiddenResult.fold<int>(0, (a, b) => max(a, b.length));

    hiddenResult = hiddenResult
        .map(
          (e) => e.replaceAll('\n', ' ' * (biggestLine - e.length) + ' \n'),
        )
        .toList();

    final outputResult = <String>[];

    final mapOutput = outputLayer
        .map((e) => e.weights.map((w) => w.toString()).toList())
        .toList();

    for (final neuron in mapOutput) {
      final neuronLength = neuron.fold<int>(0, (a, b) => max(a, b.length));

      outputResult.add('┏━' + ('━' * neuronLength) + '━┓\n');

      for (final weight in neuron) {
        outputResult.add(
          '┃ ' + weight + (' ' * (neuronLength - weight.length)) + ' ┃\n',
        );
      }

      outputResult.add('┗━' + ('━' * neuronLength) + '━┛\n');
    }

    final biggestResult =
        hiddenResult.length > outputResult.length ? hiddenResult : outputResult;

    final smallestResult =
        biggestResult == hiddenResult ? outputResult : hiddenResult;

    final difference = biggestResult.length - smallestResult.length;

    for (var i = 0; i < difference; i++) {
      smallestResult.add((' ' * (smallestResult.last.length - 1)) + '\n');
    }

    var result = '';
    for (var line = 0; line < biggestResult.length; line++) {
      result += hiddenResult[line].replaceFirst('\n', outputResult[line]);
    }

    return result;
  }
}

Network fromFile(String path) {
  final file = File(path);
  assert(file.existsSync(), 'File does not exist');
  assert(file.path.endsWith('.h8'), 'File must be a H8 file');

  final network = Network.empty();
  final content = file.readAsStringSync();

  final regexp = RegExp(r'([│║┃][\ ][-]?([0-9]+\.[0-9]*))|[═━]+');
  final data = regexp.allMatches(content).map((e) => e.group(0)!).toList();

  final hiddenLayer = <Neuron>[];
  final outputLayer = <Neuron>[];

  var hiddenNeuronWeights = <double>[];
  var isLoadingHiddenWeights = false;

  var outputNeuronWeights = <double>[];
  var isLoadingOutputWeights = false;

  for (final match in data) {
    if (match.startsWith('│')) {
      network.bias = double.tryParse(match.substring(2)) ?? 1.0;
    } else if (match.startsWith('═')) {
      if (isLoadingHiddenWeights) {
        hiddenLayer.add(Neuron.fromWeights(weights: hiddenNeuronWeights));
        hiddenNeuronWeights = [];
      }

      isLoadingHiddenWeights = !isLoadingHiddenWeights;
    } else if (match.startsWith('━')) {
      if (isLoadingOutputWeights) {
        outputLayer.add(Neuron.fromWeights(weights: outputNeuronWeights));
        outputNeuronWeights = [];
      }

      isLoadingOutputWeights = !isLoadingOutputWeights;
    } else if (match.startsWith('║')) {
      hiddenNeuronWeights.add(double.tryParse(match.substring(2)) ?? 0);
    } else if (match.startsWith('┃')) {
      outputNeuronWeights.add(double.tryParse(match.substring(2)) ?? 0);
    }
  }

  network.hiddenLayer = hiddenLayer;
  network.outputLayer = outputLayer;

  return network;
}
