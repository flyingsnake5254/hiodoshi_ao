/*
1.所有 ViewModel 都要繼承次類。
2.此類會引入 GlobalViewModel （存放全局狀態），若要存取、修改全局變數，須在此類撰寫 get, set 方法
3.當布局狀態有變更時，可以呼叫 setBusy() 以更新布局
*/
import 'package:hiodoshi_ao/locator.dart';
import 'package:hiodoshi_ao/viewmodels/global_view_model.dart';
import 'package:flutter/cupertino.dart';

class BaseViewModel extends ChangeNotifier {
  final GlobalViewModel globalViewModel = locator<GlobalViewModel>();

  bool _busy = false; // 是否忙碌中
  bool get busy => _busy;

  bool _disposed = false; // 是否已經被釋放
  bool get disposed => _disposed;

  late BuildContext _context; // 目前頁面
  BuildContext get context => _context;

  @override
  void dispose(){
    super.dispose();
    _disposed = true;
  }

  @override
  void notifyListeners(){
    if(!disposed) super.notifyListeners();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void initViewModel(BuildContext context) {
    globalViewModel.initGlobalViewModel();
    setBusy(true);
    _context = context;
    setBusy(false);
  }
}

