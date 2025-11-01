import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiodoshi_ao/ui/pages/base_view.dart';
import 'package:hiodoshi_ao/viewmodels/test_page_view_model.dart';

@RoutePage()
class TestPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView(
        builder: (context, model, child) {
          return Scaffold();
        },
        modelProvider: () => TestPageViewModel(),
    );
  }

}