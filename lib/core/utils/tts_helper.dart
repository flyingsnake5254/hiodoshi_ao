import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:io' show Platform;

class TtsHelper {
  static final FlutterTts _tts = FlutterTts();
  static bool _inited = false;

  static bool get _isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get _isIOS     => !kIsWeb && Platform.isIOS;
  static bool get _isMacOS   => !kIsWeb && Platform.isMacOS;
  static bool get _isLinux   => !kIsWeb && Platform.isLinux;

  static bool get _supportsAwait => _isAndroid || _isIOS || _isMacOS; // Linux/Web 不支援
  static bool get _supportsRate  => _isAndroid || _isIOS || _isMacOS;
  static bool get _supportsPitch => _isAndroid || _isIOS || _isMacOS;

  static Future<void> init() async {
    if (_inited) return;
    _inited = true;

    // 💡 iOS 真機常需要 AudioSession 設定
    if (_isIOS) {
      try {
        await _tts.setSharedInstance(true);
        await _tts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
            IosTextToSpeechAudioCategoryOptions.mixWithOthers,
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
          ],
          IosTextToSpeechAudioMode.defaultMode,
        );
      } catch (_) {}
    }

    if (_supportsAwait) { try { await _tts.awaitSpeakCompletion(true); } catch (_) {} }
    if (_supportsRate)  { try { await _tts.setSpeechRate(0.5); } catch (_) {} }
    if (_supportsPitch) { try { await _tts.setPitch(1.0);      } catch (_) {} }

    if (kIsWeb) {
      await _ensureWebVoicesLoaded(); // 只在 Web 等待 voices
    }
  }

  static Future<void> _ensureWebVoicesLoaded() async {
    for (int i = 0; i < 10; i++) {
      final voices = await _tts.getVoices; // List<Map>
      if (voices is List && voices.isNotEmpty) return;
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  // 💡 Web：確認是否真的有 voice（沒有就別硬播）
  static Future<bool> _webHasVoices() async {
    try {
      final voices = await _tts.getVoices;
      return voices is List && voices.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _setLangSmart(String lang) async {
    if (_supportsRate || _supportsPitch || _supportsAwait) {
      try { await _tts.setLanguage(lang); } catch (_) {}
      return;
    }

    if (kIsWeb) {
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
      try { await _tts.setLanguage(lang); } catch (_) {}
      return;
    }
  }

  static Duration _estimate(String text) {
    final len = text.runes.length;
    final ms = 500 + len * 60;
    return Duration(milliseconds: ms.clamp(400, 12000));
  }

  /// 依序朗讀：[(語系, 文字), ...]
  static Future<void> speakSeq(List<(String lang, String text)> seq) async {
    await init();

    // 💡 Web：若沒有任何 voice，直接丟清楚的錯誤讓 UI 顯示
    if (kIsWeb && !await _webHasVoices()) {
      throw '此瀏覽器目前沒有可用的語音（voices）。請安裝系統 TTS（如 espeak-ng / speech-dispatcher），並重啟瀏覽器。';
    }

    for (final (lang, raw) in seq) {
      final text = raw.trim();
      if (text.isEmpty) continue;

      await _setLangSmart(lang);
      await _tts.speak(text);

      if (_supportsAwait) {
        // Android/iOS/macOS：會等講完（init 已開 awaitSpeakCompletion）
      } else {
        await Future.delayed(_estimate(text)); // Web/Linux：估時串接
      }
    }
  }

  static Future<void> stop() => _tts.stop();
}
