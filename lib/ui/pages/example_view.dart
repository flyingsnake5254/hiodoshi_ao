import 'package:auto_route/annotations.dart';
import 'package:hiodoshi_ao/core/services/log_service.dart';
import 'package:hiodoshi_ao/ui/pages/base_view.dart';
import 'package:hiodoshi_ao/viewmodels/example_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ExampleView extends StatelessWidget {
  const ExampleView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      builder: (context, model, child) {
        // return widget
        LogService.d('value : ' + model.exampleVariable.toString());
        return Scaffold(
          backgroundColor: Colors.red,
          appBar: AppBar(title: Text('appbar'),),
          body: Center(
            child: Text("example view"),
          ),
        );
      },
      modelProvider: () => ExampleViewModel(),
    );
  }
}