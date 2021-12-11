import 'dart:convert';
import 'dart:io';

void main() {
  final data = (jsonDecode(
    File(
      './waifus_filtered.json',
    ).readAsStringSync(),
  ) as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList();

  /// Responsible to adjust and lower scores if they have a good percentage of
  /// upvotes but a low amount of votes.
  ///
  /// This value was selected based on the average amount of votes per waifu.
  /// average = 157.1885593220339
  /// bias ~= average / 3
  final popularityBias = 52;

  for (final waifu in data) {
    final likes = waifu['likes'] as int;
    final dislikes = waifu['trash'] as int;
    final total = likes + dislikes;

    waifu['score'] = (likes + 1) / (total + popularityBias);
  }

  File('./waifus_scored.json').writeAsStringSync(jsonEncode(data));
}
