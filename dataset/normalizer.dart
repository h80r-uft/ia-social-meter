import 'dart:convert';
import 'dart:io';

void normalizer(Map<String, dynamic> waifu) {
  if (maxxedWaifu == null) setMaxxedWaifu();

  waifu['age'] = (waifu['age'] / maxxedWaifu!['age']) * 2 - 1;
  waifu['bust'] = (waifu['bust'] / maxxedWaifu!['bust']) * 2 - 1;
  waifu['height'] = (waifu['height'] / maxxedWaifu!['height']) * 2 - 1;
  waifu['weight'] = (waifu['weight'] / maxxedWaifu!['weight']) * 2 - 1;
  waifu['hip'] = (waifu['hip'] / maxxedWaifu!['hip']) * 2 - 1;
  waifu['waist'] = (waifu['waist'] / maxxedWaifu!['waist']) * 2 - 1;
  try {
    waifu['likes'] = (waifu['likes'] / maxxedWaifu!['likes']) * 2 - 1;
    waifu['trash'] = (waifu['trash'] / maxxedWaifu!['trash']) * 2 - 1;
  } catch (e) {
    print('This waifu has no trash or likes');
  }
}

List<Map<String, dynamic>>? filteredData;
Map<String, dynamic>? maxxedWaifu;

void setMaxxedWaifu() {
  if (filteredData == null) loadData();

  maxxedWaifu = filteredData!.fold<Map<String, double>>(
    {
      'age': 0.0,
      'bust': 0.0,
      'height': 0.0,
      'weight': 0.0,
      'hip': 0.0,
      'waist': 0.0,
      'likes': 0.0,
      'trash': 0.0,
    },
    (max, waifu) => {
      'age': waifu['age'] > max['age'] ? waifu['age'] * 1.01 : max['age'],
      'bust': waifu['bust'] > max['bust'] ? waifu['bust'] * 1.01 : max['bust'],
      'height': waifu['height'] > max['height']
          ? waifu['height'] * 1.01
          : max['height'],
      'weight': waifu['weight'] > max['weight']
          ? waifu['weight'] * 1.01
          : max['weight'],
      'hip': waifu['hip'] > max['hip'] ? waifu['hip'] * 1.01 : max['hip'],
      'waist':
          waifu['waist'] > max['waist'] ? waifu['waist'] * 1.01 : max['waist'],
      'likes':
          waifu['likes'] > max['likes'] ? waifu['likes'] * 1.01 : max['likes'],
      'trash':
          waifu['trash'] > max['trash'] ? waifu['trash'] * 1.01 : max['trash'],
    },
  );
}

void loadData() {
  filteredData = (jsonDecode(
    File(
      './dataset/waifus_filtered.json',
    ).readAsStringSync(),
  ) as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();
}

void main() {
  loadData();
  setMaxxedWaifu();

  final normalizedData = [...filteredData!]
    ..forEach((waifu) => normalizer(waifu));

  File('./dataset/waifus_normalized.json').writeAsStringSync(
    jsonEncode(normalizedData),
  );
}
