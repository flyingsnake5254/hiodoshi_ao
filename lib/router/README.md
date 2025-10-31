# Flutter router 路由說明
- 本專案採用套件來實作路由，免於自行撰寫大量跳頁的邏輯 [auto_route](https://pub.dev/packages/auto_route) 套件
- 相關使用方式請參見文檔 [auto_route package > documentation](https://pub.dev/documentation/auto_route/latest/)

## 指令
```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 結構說明
```
專案:.
├─router (相關路由程式碼主要資料夾，在此放置路由表、自訂路由器、guard等)
│  ├─custom_router (放置一些自訂路由器的相關程式碼，像是空白的路由器)
│  ├─guard (放置 guard 的相關程式碼，guard 可以想像是 web 端的 middleware，像是驗證登入狀態)
│  ├─app_router.dart (app 的路由表)
│  └─app_router.gr.dart (auto_route 生成的檔案，不要手動修改)
└─...
```

## 其他說明
- 路由表的設定在 `router/app_router.dart` 中，可以在此設定路由
- 路由表設定後，如需更新路由程式碼，請執行 `flutter packages pub run build_runner build --delete-conflicting-outputs` 來重新產生路由程式碼
- 產生路由程式碼時，會歷閱整個專案有宣告路由的地方(@RoutePage())，並產生相對應的程式碼
- 路由產生的程式碼檔案在 `router/app_router.gr.dart` 中，不要手動修改
- 路由表的設定方式請參見文檔 [auto_route package > documentation](https://pub.dev/documentation/auto_route/latest/)
