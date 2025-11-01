import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hiodoshi_ao/core/models/word.dart';
import 'package:hiodoshi_ao/core/services/log_service.dart';
import 'package:hiodoshi_ao/core/utils/tts_helper.dart';
import 'package:hiodoshi_ao/core/utils/utils.dart';

@RoutePage()
class WordListPageView extends StatelessWidget {
  const WordListPageView({@PathParam('date') required this.date});

  final String date;

  // 共用一個 TTS 實例，避免每次點擊都 new
  static final FlutterTts _tts = FlutterTts();

  // 依序朗讀：英文單字 → 中文 → 英文例句 → 中文例句
  static Future<void> _speakWord(Word w) async {
    // 建議：確保逐段等待朗讀完成
    await _tts.awaitSpeakCompletion(true);

    // 可選：基本設定
    await _tts.setSpeechRate(0.5); // 0.0~1.0
    await _tts.setPitch(1.0);

    // 1) 英文單字
    if (w.word.trim().isNotEmpty) {
      await _tts.setLanguage('en-US');
      await _tts.speak(w.word.trim());
      // 等待這段講完
      // （因 awaitSpeakCompletion(true) 已開，所以 await speak() 後會等完成）
    }

    // 2) 中文釋義
    if (w.wordCN.trim().isNotEmpty) {
      await _tts.setLanguage('zh-TW'); // 或 'zh-CN' 視你需求
      await _tts.speak(w.wordCN.trim());
    }

    // 3) 英文例句
    if (w.exampleSentences.trim().isNotEmpty) {
      await _tts.setLanguage('en-US');
      await _tts.speak(w.exampleSentences.trim());
    }

    // 4) 中文例句
    if (w.exampleSentencesCN.trim().isNotEmpty) {
      await _tts.setLanguage('zh-TW');
      await _tts.speak(w.exampleSentencesCN.trim());
    }
  }

  String _fmt(String yyyymmdd) {
    if (yyyymmdd.length != 8) return yyyymmdd;
    return '${yyyymmdd.substring(0,4)} / ${yyyymmdd.substring(4,6)} / ${yyyymmdd.substring(6,8)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('單字｜${_fmt(date)}')),
      body: FutureBuilder<List<Word>>(
        future: Utils.loadWordsFromCsvAsset('assets/words/$date.csv'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('載入失敗：${snapshot.error}'));
          }
          final words = snapshot.data ?? [];
          if (words.isEmpty) {
            return const Center(child: Text('這天沒有單字資料'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16), // 不用刻意加大底部 padding
            itemCount: words.length,
            separatorBuilder: (_, __) => const Divider(height: 16),
            itemBuilder: (context, i) {
              final w = words[i];
              return ListTile(
                onTap: () async {
                  try {
                    await TtsHelper.speakSeq([
                      ('en-US', w.word),
                      ('zh-TW', w.wordCN),
                      ('en-US', w.exampleSentences),
                      ('zh-TW', w.exampleSentencesCN),
                    ]);
                  } catch (e) {
                    LogService.e('朗讀失敗：$e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('朗讀失敗：$e')),
                    );
                  }
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                tileColor: Colors.white,
                title: Text('${w.word}  —  ${w.wordCN}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (w.kk.isNotEmpty) Text(w.kk),
                      if (w.exampleSentences.isNotEmpty) Text(w.exampleSentences),
                      if (w.exampleSentencesCN.isNotEmpty)
                        Text(w.exampleSentencesCN, style: const TextStyle(color: Colors.black54)),
                      if (w.note.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text('備註：${w.note}', style: const TextStyle(color: Colors.black87)),
                        ),
                    ],
                  ),
                ),
                trailing: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('評量次數 ${w.practiceTimes} 次'),
                      Text('評量正確率 ${w.practiceAcc.toStringAsFixed(0)}%'),
                      Text('測驗次數 ${w.testTimes} 次'),
                      Text('測驗正確率 ${w.testAcc.toStringAsFixed(0)}%'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // 這裡新增固定底部的按鈕
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              // 第一個按鈕
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // 範例：全部朗讀
                      try {
                        final words = await Utils.loadWordsFromCsvAsset('assets/words/$date.csv');
                        for (final w in words) {
                          await TtsHelper.speakSeq([
                            ('en-US', w.word),
                            ('zh-TW', w.wordCN),
                            ('en-US', w.exampleSentences),
                            ('zh-TW', w.exampleSentencesCN),
                          ]);
                        }
                      } catch (e) {
                        LogService.e('朗讀失敗：$e');
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('朗讀失敗：$e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.volume_up),
                    label: const Text('全部朗讀'),
                  ),
                ),
              ),
              const SizedBox(width: 12), // 兩個按鈕間距
              // 第二個按鈕
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // 範例：切換模式或顯示統計
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('進入測驗模式！')),
                      );
                    },
                    icon: const Icon(Icons.quiz),
                    label: const Text('測驗模式'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // 可自訂顏色
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),


      backgroundColor: const Color(0xFFF5F6FA),
    );
  }
}
