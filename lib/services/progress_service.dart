import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Central, persisted app state: stars, streaks, badges, and settings.
/// Backed by shared_preferences, exposed as a ChangeNotifier so any
/// screen can watch it via `provider`.
class ProgressService extends ChangeNotifier {
  static const List<String> topics = ['colors', 'numbers', 'letters', 'shapes', 'animals', 'stories'];

  static const Map<String, String> topicLabels = {
    'colors': 'Colors',
    'numbers': 'Numbers',
    'letters': 'Alphabets',
    'shapes': 'Shapes',
    'animals': 'Animals',
    'stories': 'Stories',
  };

  static const Map<String, String> badgeLabels = {
    'colors_master': '🎨 Color Master',
    'numbers_master': '🔢 Number Ninja',
    'letters_master': '🔤 Alphabet Ace',
    'shapes_master': '🔺 Shape Star',
    'animals_master': '🐾 Animal Expert',
    'stories_master': '📚 Story Lover',
  };

  static const int _badgeThreshold = 50;

  late SharedPreferences _prefs;
  bool loaded = false;

  int totalStars = 0;
  final Map<String, int> starsByTopic = {};

  int currentStreak = 0;
  int longestStreak = 0;
  DateTime? lastActiveDate;

  bool soundOn = true;
  bool ttsOn = true;

  final Set<String> badges = {};
  Set<String> _practicedToday = {};

  bool parentGateUnlockedThisSession = false;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    totalStars = _prefs.getInt('stars_total') ?? 0;
    for (final topic in topics) {
      starsByTopic[topic] = _prefs.getInt('stars_$topic') ?? 0;
    }

    currentStreak = _prefs.getInt('streak_current') ?? 0;
    longestStreak = _prefs.getInt('streak_longest') ?? 0;
    final lastStr = _prefs.getString('streak_last_active');
    lastActiveDate = lastStr != null ? DateTime.tryParse(lastStr) : null;

    soundOn = _prefs.getBool('setting_sound_on') ?? true;
    ttsOn = _prefs.getBool('setting_tts_on') ?? true;

    badges.addAll(_prefs.getStringList('badges') ?? []);
    _practicedToday = (_prefs.getStringList('practiced_${_todayKey()}') ?? []).toSet();

    await _registerVisitAndUpdateStreak();

    loaded = true;
    notifyListeners();
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> _registerVisitAndUpdateStreak() async {
    final today = _dateOnly(DateTime.now());
    if (lastActiveDate == null) {
      currentStreak = 1;
    } else {
      final diff = today.difference(_dateOnly(lastActiveDate!)).inDays;
      if (diff == 1) {
        currentStreak += 1;
      } else if (diff > 1) {
        currentStreak = 1;
      }
      // diff == 0 (same day): streak unchanged.
    }
    if (currentStreak > longestStreak) longestStreak = currentStreak;
    lastActiveDate = today;

    await _prefs.setInt('streak_current', currentStreak);
    await _prefs.setInt('streak_longest', longestStreak);
    await _prefs.setString('streak_last_active', today.toIso8601String());
  }

  Future<void> addStars(String topic, int amount) async {
    totalStars += amount;
    starsByTopic[topic] = (starsByTopic[topic] ?? 0) + amount;
    await _prefs.setInt('stars_total', totalStars);
    await _prefs.setInt('stars_$topic', starsByTopic[topic]!);
    _checkBadge(topic);
    notifyListeners();
  }

  void _checkBadge(String topic) {
    final badgeId = '${topic}_master';
    if ((starsByTopic[topic] ?? 0) >= _badgeThreshold && !badges.contains(badgeId)) {
      badges.add(badgeId);
      _prefs.setStringList('badges', badges.toList());
    }
  }

  bool hasPracticedToday(String itemKey) => _practicedToday.contains(itemKey);

  Future<void> markPracticedToday(String itemKey) async {
    if (_practicedToday.add(itemKey)) {
      await _prefs.setStringList('practiced_${_todayKey()}', _practicedToday.toList());
    }
  }

  Future<void> setSoundOn(bool value) async {
    soundOn = value;
    await _prefs.setBool('setting_sound_on', value);
    notifyListeners();
  }

  Future<void> setTtsOn(bool value) async {
    ttsOn = value;
    await _prefs.setBool('setting_tts_on', value);
    notifyListeners();
  }

  void unlockParentGateForSession() {
    parentGateUnlockedThisSession = true;
    notifyListeners();
  }

  Future<void> resetProgress() async {
    totalStars = 0;
    for (final topic in topics) {
      starsByTopic[topic] = 0;
      await _prefs.setInt('stars_$topic', 0);
    }
    await _prefs.setInt('stars_total', 0);

    currentStreak = 0;
    longestStreak = 0;
    lastActiveDate = null;
    await _prefs.remove('streak_current');
    await _prefs.remove('streak_longest');
    await _prefs.remove('streak_last_active');

    badges.clear();
    await _prefs.setStringList('badges', []);

    notifyListeners();
  }
}
