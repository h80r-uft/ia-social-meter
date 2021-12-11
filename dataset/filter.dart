import 'dart:convert';
import 'dart:io';

void main(List<String> arguments) {
  final file = File('./waifus_raw.json');

  final json = (jsonDecode(file.readAsStringSync()) as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();

  final filtered = json
      .where((e) =>
          e['age'] != null &&
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
            'bust': filtered[index]['bust'],
            'height': filtered[index]['height'],
            'weight': filtered[index]['weight'],
            'hip': filtered[index]['hip'],
            'waist': filtered[index]['waist'],
            'likes': filtered[index]['likes'],
            'trash': filtered[index]['trash'],
          });

  final filteredFile = File('./waifus_filtered.json');
  filteredFile.writeAsStringSync(jsonEncode(waifus));
}
