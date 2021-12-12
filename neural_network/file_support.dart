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

    result += signature() + '\n';

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

String signature() {
  return [
    [
      10244,
      10244,
      10244,
      10494,
      10495,
      10303,
      10303,
      10294,
      10303,
      10431,
      10495,
      10495,
      10495,
      10495,
      10470,
      10468,
      10436,
      10368,
      10309,
      10400,
      10494,
      10459,
      10313,
      10244,
      10244,
      10244,
      10296,
      10368,
      10495,
      10244
    ],
    [
      10244,
      10244,
      10368,
      10315,
      10465,
      10484,
      10486,
      10486,
      10304,
      10244,
      10244,
      10265,
      10431,
      10495,
      10495,
      10495,
      10495,
      10495,
      10484,
      10495,
      10495,
      10495,
      10371,
      10468,
      10436,
      10432,
      10469,
      10495,
      10495,
      10244
    ],
    [
      10244,
      10244,
      10424,
      10439,
      10299,
      10495,
      10495,
      10495,
      10471,
      10432,
      10368,
      10464,
      10316,
      10427,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10303,
      10303,
      10303,
      10495,
      10495,
      10495,
      10244
    ],
    [
      10244,
      10368,
      10424,
      10495,
      10487,
      10468,
      10468,
      10468,
      10476,
      10457,
      10459,
      10431,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10367,
      10495,
      10495,
      10317,
      10244,
      10244,
      10368,
      10468,
      10436,
      10249,
      10251,
      10480
    ],
    [
      10244,
      10492,
      10454,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10431,
      10495,
      10495,
      10495,
      10495,
      10495,
      10375,
      10495,
      10495,
      10359,
      10294,
      10294,
      10431,
      10495,
      10495,
      10247,
      10368,
      10468
    ],
    [
      10264,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10493,
      10495,
      10495,
      10495,
      10311,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10487,
      10486,
      10469,
      10484,
      10495,
      10327
    ],
    [
      10368,
      10248,
      10431,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10335,
      10244
    ],
    [
      10424,
      10495,
      10470,
      10444,
      10459,
      10491,
      10495,
      10495,
      10471,
      10265,
      10267,
      10267,
      10349,
      10245,
      10258,
      10278,
      10285,
      10477,
      10363,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10367,
      10243,
      10244
    ],
    [
      10264,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10310,
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10297,
      10248,
      10379,
      10493,
      10495,
      10495,
      10495,
      10495,
      10485,
      10494,
      10243,
      10244
    ],
    [
      10244,
      10264,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10244,
      10484,
      10495,
      10486,
      10436,
      10244,
      10484,
      10486,
      10244,
      10368,
      10494,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10243,
      10244,
      10244
    ],
    [
      10244,
      10244,
      10248,
      10299,
      10495,
      10495,
      10495,
      10495,
      10495,
      10495,
      10308,
      10427,
      10495,
      10495,
      10495,
      10244,
      10495,
      10495,
      10304,
      10494,
      10495,
      10495,
      10495,
      10495,
      10459,
      10267,
      10241,
      10244,
      10244,
      10244
    ],
    [
      10244,
      10244,
      10244,
      10244,
      10248,
      10267,
      10431,
      10495,
      10495,
      10495,
      10241,
      10270,
      10431,
      10495,
      10495,
      10308,
      10431,
      10495,
      10311,
      10488,
      10495,
      10495,
      10303,
      10267,
      10241,
      10244,
      10244,
      10244,
      10244,
      10244
    ],
    [
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10249,
      10299,
      10495,
      10495,
      10494,
      10470,
      10329,
      10299,
      10487,
      10494,
      10495,
      10243,
      10303,
      10251,
      10241,
      10244,
      10244,
      10244,
      10244,
      10244,
      10368,
      10464,
      10484
    ],
    [
      10495,
      10495,
      10495,
      10486,
      10486,
      10478,
      10469,
      10450,
      10290,
      10414,
      10461,
      10367,
      10495,
      10495,
      10310,
      10495,
      10367,
      10243,
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10244,
      10464,
      10484,
      10495,
      10495,
      10495
    ]
  ].map(String.fromCharCodes).join('\n');
}
