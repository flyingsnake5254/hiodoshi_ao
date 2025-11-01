import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:hiodoshi_ao/core/models/word.dart';

class Utils {
  /// 回傳格式：{ "20251101.csv": [Word, Word, ...], "20251102.csv": [...] }
  static Future<Map<String, List<Word>>> loadAllWordsGroupedByCsv() async {
    // 1) 從 AssetManifest.json 找出 assets/words/ 內所有 csv 檔
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = json.decode(manifestContent);

    final csvAssets = manifest.keys
        .where((p) => p.startsWith('assets/words/'))
        .where((p) => p.toLowerCase().endsWith('.csv'))
        .toList();

    // 2) 逐檔讀取
    final Map<String, List<Word>> result = {};
    for (final assetPath in csvAssets) {
      final words = await loadWordsFromCsvAsset(assetPath);
      final fileName = basename(assetPath); // 例如 "20251101.csv"
      result[fileName] = words;
    }
    return result;
  }

  /// 單檔 CSV → List<Word>
  /// 欄位順序（無標題列）：
  /// 0: word, 1: wordCN, 2: kk, 3: exampleSentences, 4: exampleSentencesCN,
  /// 5: note, 6: practiceTimes, 7: practiceAcc, 8: testTimes, 9: testAcc
  static Future<List<Word>> loadWordsFromCsvAsset(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath, cache: true);

    // 去 UTF-8 BOM（若存在）
    final sanitized = raw.isNotEmpty && raw.codeUnitAt(0) == 0xFEFF
        ? raw.substring(1)
        : raw;

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false, // 先全部當字串，再自行轉型
    ).convert(sanitized);

    final dateStr = filenameWithoutExt(basename(assetPath));
    final List<Word> out = [];

    for (final row in rows) {
      if (row.isEmpty || row.every((c) => (c?.toString().trim().isEmpty ?? true))) {
        continue; // 跳過空列
      }

      // 安全取值（不足欄位時給空字串）
      String _s(List r, int i) => (i < r.length ? r[i] : '').toString().trim();

      final wordStr = _s(row, 0);
      final wordCnStr = _s(row, 1);
      if (wordStr.isEmpty && wordCnStr.isEmpty) continue; // 無效列

      final kkStr  = _s(row, 2);
      final exEn   = _s(row, 3);
      final exZh   = _s(row, 4);
      final note   = _s(row, 5);

      int    practiceTimes = toIntSafe(_s(row, 6));
      double practiceAcc   = toDoubleSafe(_s(row, 7));
      int    testTimes     = toIntSafe(_s(row, 8));
      double testAcc       = toDoubleSafe(_s(row, 9));

      final w = Word(wordStr, wordCnStr);
      w.date = dateStr;
      w.kk = kkStr;
      w.exampleSentences = exEn;
      w.exampleSentencesCN = exZh;
      w.note = note;
      w.practiceTimes = practiceTimes;
      w.practiceAcc = practiceAcc;
      w.testTimes = testTimes;
      w.testAcc = testAcc;

      out.add(w);
    }

    return out;
  }

  static int toIntSafe(String s, [int fallback = 0]) {
    if (s.isEmpty) return fallback;
    final v = int.tryParse(s);
    return v ?? fallback;
  }

  static double toDoubleSafe(String s, [double fallback = 0.0]) {
    if (s.isEmpty) return fallback;
    // 兼容用逗號作小數點的情況
    final v = double.tryParse(s.replaceAll(',', '.'));
    return v ?? fallback;
  }

  static String basename(String path) {
    final i = path.lastIndexOf('/');
    return (i >= 0) ? path.substring(i + 1) : path;
  }

  static String filenameWithoutExt(String filename) {
    final i = filename.lastIndexOf('.');
    return (i > 0) ? filename.substring(0, i) : filename;
  }


}