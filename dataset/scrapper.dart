import 'dart:convert';
import 'dart:io';

final http = HttpClient();

void main() async {
  final finalId = 43399; // Último valor testado que retorna um resultado válido

  final waifus = <Map<String, dynamic>>[];

  final scrappingTimer = Stopwatch()..start();
  for (var id = 1; id <= finalId; id++) {
    final waifu = await getWaifu(id);
    if (waifu == null) continue;

    waifus.add(waifu);

    print(Process.runSync('clear', [], runInShell: true).stdout);
    print('Scrapped ${id * 100 / finalId}%');
  }
  scrappingTimer.stop();

  final savingTimer = Stopwatch()..start();
  final json = jsonEncode(waifus);
  final file = File('./waifus_raw.json');
  file.writeAsStringSync(json);
  savingTimer.stop();

  print('Scrapping time: ${scrappingTimer.elapsed}');
  print('Saving time: ${savingTimer.elapsed}');

  return;
}

Future<Map<String, dynamic>?> getWaifu(int id) async {
  final url = 'https://mywaifulist.moe/api/waifu/$id';
  try {
    final request = await http.getUrl(Uri.parse(url));
    request.headers.add('x-requested-with', 'XMLHttpRequest');
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    return jsonDecode(responseBody) as Map<String, dynamic>;
  } catch (e) {
    return null;
  }
}
