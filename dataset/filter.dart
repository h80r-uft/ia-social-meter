import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  final file = File('./dataset/waifus_raw.json');

  final json = (jsonDecode(file.readAsStringSync()) as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();

  final filtered = json
      .where((e) =>
          e['age'] != null &&
          e['age'] != 0 &&
          e['bust'] != null &&
          e['height'] != null &&
          e['weight'] != null &&
          e['hip'] != null &&
          e['waist'] != null)
      .toList();

  final waifus = List.generate(
      filtered.length,
      (index) => {
            'id': filtered[index]['id'],
            'name': filtered[index]['name'],
            'age': filtered[index]['age'],
            'bust': double.parse(filtered[index]['bust']),
            'height': double.parse(filtered[index]['height']),
            'weight': double.parse(filtered[index]['weight']),
            'hip': double.parse(filtered[index]['hip']),
            'waist': double.parse(filtered[index]['waist']),
            'likes': filtered[index]['likes'],
            'trash': filtered[index]['trash'],
          });

  final filteredFile = File('./dataset/waifus_filtered.json');
  filteredFile.writeAsStringSync(jsonEncode(waifus));
}
