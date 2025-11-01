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

  // await / rate / pitch：Android / iOS / macOS 支援；Linux / Web 多半不支援
  static bool get _supportsAwait => _isAndroid || _isIOS || _isMacOS;
  static bool get _supportsRate  => _isAndroid || _isIOS || _isMacOS;
  static bool get _supportsPitch => _isAndroid || _isIOS || _isMacOS;

  static Future<void> init() async {
    if (_inited) return;
    _inited = true;

    // iOS 實機常需要先設 AudioSession
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
      await _ensureWebVoicesLoaded(); // 首次載入時先把 voices 喚醒
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Web：行動 Chrome 常回傳空 voices，使用「喚醒技巧」+ 較長等待。
  static Future<void> _ensureWebVoicesLoaded() async {
    Future<void> _wake() async {
      try {
        await _tts.speak(' ');
        await Future.delayed(const Duration(milliseconds: 50));
        await _tts.stop();
      } catch (_) {}
    }

    await _wake();
    for (int i = 0; i < 40; i++) { // 最多 ~8s
      final voices = await _tts.getVoices;
      if (voices is List && voices.isNotEmpty) return;
      await _wake();
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  static Future<bool> _webHasVoices() async {
    try {
      final voices = await _tts.getVoices;
      return voices is List && voices.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // 語系回退表：盡量對上各裝置的實際語系代碼
  static List<String> _fallbackLocales(String want) {
    final w = want.toLowerCase();
    if (w.startsWith('zh-tw')) return ['cmn-hant-tw', 'zh-tw', 'zh'];
    if (w.startsWith('zh-cn')) return ['cmn-hans-cn', 'zh-cn', 'zh'];
    if (w.startsWith('zh-hk')) return ['yue-hant-hk', 'zh-hk', 'zh'];
    if (w.startsWith('zh'))    return ['cmn-hant-tw', 'cmn-hans-cn', 'zh'];
    if (w.startsWith('en-us')) return ['en-us', 'en-gb', 'en'];
    if (w.startsWith('en'))    return ['en-us', 'en-gb', 'en'];
    return [want];
  }

  static Map<String, dynamic>? _pickBestVoice(List voices, List<String> wants) {
    Map<String, dynamic>? pickBy(bool Function(Map m) pred) {
      for (final v in voices) {
        final m = Map<String, dynamic>.from(v as Map);
        if (pred(m)) return m;
      }
      return null;
    }

    for (final target in wants) {
      final t = target.toLowerCase();

      // 先找 locale/lan 等於或前綴，且名稱含 Google 的 voice
      final g = pickBy((m) {
        final loc = (m['locale'] ?? m['lang'] ?? '').toString().toLowerCase();
        final name = (m['name'] ?? '').toString().toLowerCase();
        return (loc == t || loc.startsWith(t)) && name.contains('google');
      });
      if (g != null) return g;

      // 再找 locale/lan 等於或前綴的任意 voice
      final m = pickBy((mm) {
        final loc = (mm['locale'] ?? mm['lang'] ?? '').toString().toLowerCase();
        return (loc == t || loc.startsWith(t));
      });
      if (m != null) return m;
    }

    // 退而求其次：Google 任意 voice
    final anyGoogle = pickBy((m) => (m['name'] ?? '').toString().toLowerCase().contains('google'));
    if (anyGoogle != null) return anyGoogle;

    // 最後：第一個
    return voices.isNotEmpty ? Map<String, dynamic>.from(voices.first as Map) : null;
  }

  // Web：選擇最合適 voice；其他平台直接 setLanguage 即可
  static Future<void> _setLangSmart(String lang) async {
    if (!kIsWeb) {
      try { await _tts.setLanguage(lang); } catch (_) {}
      return;
    }

    final voices = (await _tts.getVoices) as List? ?? [];
    if (voices.isEmpty) return;

    final wants = { lang.toLowerCase(), ..._fallbackLocales(lang) }.toList();
    final chosen = _pickBestVoice(voices, wants);
    if (chosen != null) {
      try {
        await _tts.setVoice({
          'name':  chosen['name'],
          'locale': chosen['locale'] ?? chosen['lang'],
        });
      } catch (_) {}
      try {
        await _tts.setLanguage(
          (chosen['locale'] ?? chosen['lang'] ?? lang).toString(),
        );
      } catch (_) {}
    } else {
      try { await _tts.setLanguage(lang); } catch (_) {}
    }
  }

  // 粗估講話時間（Web/Linux 用於串接）
  static Duration _estimate(String text) {
    final len = text.runes.length;
    final ms = 500 + len * 60;
    return Duration(milliseconds: ms.clamp(400, 12000));
  }

  /// 依序朗讀：[(語系, 文字), ...]
  static Future<void> speakSeq(List<(String lang, String text)> seq) async {
    await init();

    if (kIsWeb) {
      await _ensureWebVoicesLoaded();          // 每次朗讀前再喚醒一次
      if (!await _webHasVoices()) {
        throw '此瀏覽器目前沒有可用的語音（voices）。\n'
            '請在手機安裝或啟用 Google 語音服務並下載英/中文語音資料，\n'
            '然後關閉分頁重新開啟。';
      }
    }

    for (final (lang, raw) in seq) {
      final text = raw.trim();
      if (text.isEmpty) continue;

      await _setLangSmart(lang);
      await _tts.speak(text);

      if (_supportsAwait) {
        // Android / iOS / macOS：awaitSpeakCompletion(true) 已生效
      } else {
        // Web / Linux：用估時 + 緩衝避免後段被吞
        await Future.delayed(_estimate(text) + const Duration(milliseconds: 250));
      }
    }
  }

  static Future<void> stop() => _tts.stop();
}
