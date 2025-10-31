```dart
import 'package:flutter/material.dart';
import 'package:your_project/core/services/api_service.dart';
import 'package:your_project/locator.dart';

class UserViewModel extends ChangeNotifier {
  final ApiService _api = locator<ApiService>();

  Map<String, dynamic>? user;
  bool isLoading = false;

  Future<void> fetchUser(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      user = await _api.get('/users/$id');
      LogService.i("User loaded: $user");
    } catch (e, s) {
      LogService.e("Failed to load user", error: e, stackTrace: s);
    }

    isLoading = false;
    notifyListeners();
  }
}
```