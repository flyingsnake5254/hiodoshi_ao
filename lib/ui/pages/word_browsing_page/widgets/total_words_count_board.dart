import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart'; // 用 Material 小工具比較齊
import 'package:hiodoshi_ao/core/models/word.dart';
import 'package:hiodoshi_ao/core/utils/utils.dart';
import 'package:hiodoshi_ao/router/app_router.gr.dart';

class TotalWordCountBoard extends StatelessWidget {
  const TotalWordCountBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<Word>>>(
        future: Utils.loadAllWordsGroupedByCsv(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('載入失敗：${snapshot.error}'));
          }

          final data = snapshot.data ?? {};
          final total = data.values.fold<int>(0, (sum, list) => sum + list.length);

// 將 Map 轉為 List 並排序（日期新 → 上面，舊 → 下面）
          final sortedEntries = data.entries.toList()
            ..sort((a, b) {
              final dateA = int.tryParse(a.key.replaceAll('.csv', '')) ?? 0;
              final dateB = int.tryParse(b.key.replaceAll('.csv', '')) ?? 0;
              return dateB.compareTo(dateA); // 新的在上面
            });

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 單字總數卡片
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.15 > 125.5
                      ? MediaQuery.of(context).size.height * 0.15
                      : 125.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("單字總數", style: TextStyle(fontSize: 20)),
                      Text("$total", style: const TextStyle(fontSize: 50)),
                    ],
                  ),
                ),

                // 🔽 按日期排序後顯示按鈕
                ...sortedEntries.map((entry) {
                  final rawKey = entry.key.replaceAll('.csv', ''); // e.g. 20251031
                  final words = entry.value;

                  // 👉 格式化日期：20251031 → 2025 / 10 / 31
                  String formatDate(String yyyymmdd) {
                    if (yyyymmdd.length != 8) return yyyymmdd; // 防呆
                    final year = yyyymmdd.substring(0, 4);
                    final month = yyyymmdd.substring(4, 6);
                    final day = yyyymmdd.substring(6, 8);
                    return '$year / $month / $day';
                  }

                  final displayDate = formatDate(rawKey);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        print('📘 $displayDate - ${words.length} words');
                        final rawDate = rawKey; // e.g. 20251101（不含 .csv）
                        // context.router.push(TestPageRoute());
                        context.router.push(WordListPageRoute(date: rawDate));
                        // context.router.push(WordListPageRoute());
                      },
                      child: Text(
                        "$displayDate（${words.length}）",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  );
                }),

              ],
            ),
          );


        },
    );
  }
}
