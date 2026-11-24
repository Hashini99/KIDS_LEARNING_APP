import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_learning_app/services/progress_service.dart';

/// Wraps sound-effect and text-to-speech playback so every screen respects
/// the sound/TTS toggles in Settings instead of playing unconditionally.
class AudioService {
  AudioService(this._progress);

  final ProgressService _progress;
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  Future<void> playSfx(String assetFileName) async {
    if (!_progress.soundOn) return;
    await _player.play(AssetSource(assetFileName));
  }

  Future<void> speak(String text, {double pitch = 1.2, double rate = 0.45}) async {
    if (!_progress.ttsOn) return;
    await _tts.setPitch(pitch);
    await _tts.setSpeechRate(rate);
    await _tts.speak(text);
  }

  Future<void> stopSpeaking() => _tts.stop();

  void dispose() {
    _player.dispose();
    _tts.stop();
  }
}
