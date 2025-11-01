import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

class TtsHelper {
  static final FlutterTts _tts = FlutterTts();
  static bool _inited = false;

  static bool get _isAndroid     => !kIsWeb && Platform.isAndroid;
  static bool get _isIOS         => !kIsWeb && Platform.isIOS;
  static bool get _isMacOS       => !kIsWeb && Platform.isMacOS;
  static bool get _isLinux       => !kIsWeb && Platform.isLinux;

  // 哪些平台可用 awaitSpeakCompletion / setSpeechRate / setPitch
  static bool get _supportsAwait => _isAndroid || _isIOS || _isMacOS;     // ★ Linux/Web 不支援
  static bool get _supportsRate  => _isAndroid || _isIOS || _isMacOS;     // ★ Linux/Web 不支援
  static bool get _supportsPitch => _isAndroid || _isIOS || _isMacOS;     // ★ Linux/Web 不支援

  static Future<void> init() async {
    if (_inited) return;
    _inited = true;

    if (_supportsAwait) {
      try { await _tts.awaitSpeakCompletion(true); } catch (_) {}
    }
    if (_supportsRate)  { try { await _tts.setSpeechRate(0.5); } catch (_) {} }
    if (_supportsPitch) { try { await _tts.setPitch(1.0);      } catch (_) {} }

    if (kIsWeb) {
      await _ensureWebVoicesLoaded(); // ★ 只在 Web 等待 voices
    }
  }

  // ★ 只在 Web 上確保 voices 載入
  static Future<void> _ensureWebVoicesLoaded() async {
    for (int i = 0; i < 10; i++) {
      final voices = await _tts.getVoices; // List<Map>
      if (voices is List && voices.isNotEmpty) return;
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  // 聰明設定語言
  static Future<void> _setLangSmart(String lang) async {
    if (_supportsRate || _supportsPitch || _supportsAwait) {
      // Android / iOS / macOS：直接 setLanguage
      try { await _tts.setLanguage(lang); } catch (_) {}
      return;
    }

    if (kIsWeb) {
      // ★ Web：用 getVoices 挑一個最接近的 voice
      final voices = (await _tts.getVoices) as List?;
      Map? chosen;
      if (voices != null && voices.isNotEmpty) {
        for (final v in voices) {
          final m = (v as Map);
          final loc = (m['locale'] ?? m['lang'] ?? '').toString().toLowerCase();
          if (loc.startsWith(lang.toLowerCase())) { chosen = m; break; }
        }
        chosen ??= voices.first as Map;
        try { await _tts.setVoice({'name': chosen['name'], 'locale': chosen['locale'] ?? chosen['lang']}); } catch (_) {}
        try {
          if (chosen['locale'] != null) {
            await _tts.setLanguage(chosen['locale']);
          } else if (chosen['lang'] != null) {
            await _tts.setLanguage(chosen['lang']);
          } else {
            await _tts.setLanguage(lang);
          }
        } catch (_) {}
      } else {
        try { await _tts.setLanguage(lang); } catch (_) {}
      }
      return;
    }

    if (_isLinux) {
      // ★ Linux：不要用 getVoices / setVoice，直接嘗試 setLanguage（常被忽略，但不會噴例外）
      try { await _tts.setLanguage(lang); } catch (_) {}
      return;
    }
  }

  // 粗估講話時間（Web/Linux 用）
  static Duration _estimate(String text) {
    final len = text.runes.length;
    final ms = 500 + len * 60; // 依需求調整
    return Duration(milliseconds: ms.clamp(400, 12000));
  }

  /// 依序朗讀：[(語系, 文字), ...]
  static Future<void> speakSeq(List<(String lang, String text)> seq) async {
    await init();

    for (final (lang, raw) in seq) {
      final text = raw.trim();
      if (text.isEmpty) continue;

      await _setLangSmart(lang);

      await _tts.speak(text);

      if (_supportsAwait) {
        // Android/iOS/macOS：init() 已開 awaitSpeakCompletion(true)，會等講完
      } else {
        // Web/Linux：用估計延遲當作串接
        await Future.delayed(_estimate(text));
      }
    }
  }

  static Future<void> stop() => _tts.stop();
}
