import 'dart:math';

import '../h8_format/file_support.dart' as FileSupport;
import 'neuron.dart';

/// Network creates a multilayer perceptron neural network, that can be trained
/// and used to predict the output of a given input.
///
/// {@tool snippet}
///
/// ```dart
/// final network = Network(
///   trainingData: trainingData,
///   learningRate: 0.5,
///   maxEpoch: 1000,
///   isOptimized: true,
/// );
/// ```
/// {@end-tool}
class Network {
  /// Creates a new [Network].
  ///
  /// [trainingData] must follow a specific format:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// final trainingData = [
  ///   {'input': [-1.0, -1.0], 'output': [-1.0]},
  ///   {'input': [-1.0, 1.0], 'output': [1.0]},
  ///   {'input': [1.0, -1.0], 'output': [1.0]},
  ///   {'input': [1.0, 1.0], 'output': [-1.0]},
  /// ];
  /// ```
  /// {@end-tool}
  Network({
    required this.trainingData,
    required double learningRate,
    this.maxEpoch = 10000,
    this.bias = 1.0,
    this.isOptimized = false,
    this.mseThreshold = 0.0008,
  })  : assert(trainingData != null, 'trainingData must not be null'),
        assert(trainingData!.isNotEmpty, 'Training data must not be empty'),
        assert(
          trainingData!.first.containsKey('input'),
          'Training data must contain an input layer',
        ),
        assert(
          trainingData!.first.containsKey('output'),
          'Training data must contain an output layer',
        ) {
    final inputCount = trainingData!.first['input']!.length;
    final outputCount = trainingData!.first['output']!.length;
    final hiddenCount = (2 * inputCount / 3 + outputCount).round();

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

  Network.empty()
      : trainingData = null,
        maxEpoch = null,
        mseThreshold = null,
        isOptimized = null;

  factory Network.fromFile(String path) {
    return FileSupport.fromFile(path);
  }

  /// The training data for the network.
  final List<Map<String, List<double>>>? trainingData;

  /// The hidden layer of neurons.
  ///
  /// This layer is responsible to receive the input data and to calculate the
  /// output of the hidden layer.
  ///
  /// The amount of neurons is determined by the following formula:
  /// `(2 * inputLayer.length / 3 + outputLayer.length)`.
  late List<Neuron> hiddenLayer;

  /// The output layer of neurons.
  ///
  /// This layer is responsible to receive the output of the hidden layer and
  /// calculate the output of the network.
  late List<Neuron> outputLayer;

  /// The max number of iterations the network will run before stopping.
  final int? maxEpoch;

  /// The network's bias.
  late final double bias;

  /// The minimum error threshold for the network to stop training before the
  /// maximum number of epochs is reached.
  ///
  /// The default value was chosen based on the average MSE of 100.000 networks,
  /// which was 0.0007092196915939188.
  final double? mseThreshold;

  /// Whether the network is optimized or not.
  final bool? isOptimized;

  /// This function sends the input data to the hidden layer.
  ///
  /// [inputs] must be the same length of the amount of weights in any hidden
  /// layer's neuron, ignoring the bias.
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

  /// This function sends the output of the hidden layer to the output layer.
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

  /// This function is responsible for calculating the network's deltas and
  /// updating the weights of the hidden and output layers.
  ///
  /// [expected] must be the same length of the amount of neurons in the
  /// output layer.
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

  /// This function makes a specific neuron in the output layer evaluate it's
  /// output.
  ///
  /// [index] must be a valid index of the output layer.
  double evaluate(int index) {
    return outputLayer[index].evaluate();
  }

  /// This function restarts the network's training.
  ///
  /// This reset recreates the network's hidden and output layers.
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

  /// This function trains the network.
  ///
  /// The returned value is the final Mean Squared Error of the network.
  double train() {
    assert(trainingData != null, 'Training data must not be null');
    assert(maxEpoch != null, 'Max epoch must not be null');
    assert(isOptimized != null, 'Is optimized must not be null');
    assert(mseThreshold != null, 'MSE threshold must not be null');

    var meanSquaredError = 0.0;

    final inputs = trainingData!.map((e) => e['input']!).toList();
    final outputs = trainingData!.map((e) => e['output']!).toList();

    for (var epoch = 0; epoch < maxEpoch!; epoch++) {
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

      if (isOptimized! && meanSquaredError < mseThreshold!) break;

      if (epoch > maxEpoch! / 5 && meanSquaredError > 1) {
        restart();
        epoch = 0;
      }
    }

    return meanSquaredError;
  }

  /// This function returns the result predicted by the trained network for
  /// the given input.
  List<double> predict(List<double> input) {
    feedForward(input);
    return outputLayer.map((e) => e.evaluate()).toList();
  }

  void saveTraining(String fileName) {
    this.toFile(fileName);
  }
}
