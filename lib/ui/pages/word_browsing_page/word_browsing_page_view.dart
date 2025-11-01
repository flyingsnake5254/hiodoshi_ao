import 'package:auto_route/annotations.dart';
import 'package:hiodoshi_ao/ui/pages/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiodoshi_ao/ui/pages/word_browsing_page/widgets/total_words_count_board.dart';
import 'package:hiodoshi_ao/viewmodels/word_browsing_page_view_model.dart';

@RoutePage()
class WordBrowsingPageView extends StatelessWidget {
  const WordBrowsingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      builder: (context, model, child) {
        return Scaffold(
          body: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TotalWordCountBoard()
              ],
            ),
          )
        );
      },
      modelProvider: () => WordBrowsingPageViewModel(),
    );
  }
}