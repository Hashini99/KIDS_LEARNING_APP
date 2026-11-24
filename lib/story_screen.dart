import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/services/progress_service.dart';
import 'package:kids_learning_app/services/audio_service.dart';
import 'package:kids_learning_app/theme/app_theme.dart';

class Story {
  final String title;
  final String emoji;
  final List<Color> gradient;
  final String content;

  const Story({required this.title, required this.emoji, required this.gradient, required this.content});
}

// Original, toddler-level stories: short sentences, repetition, gentle
// everyday themes. No stock photo can stand in for real illustrations, so
// each story gets its own colored gradient + emoji "cover" instead of the
// single reused photo the old version had.
final List<Story> stories = [
  Story(
    title: 'The Sleepy Little Bear',
    emoji: '🐻',
    gradient: const [Color(0xFF6A5ACD), Color(0xFF9575CD)],
    content:
        'Little Bear rubbed his eyes. He was very sleepy.\n\nHe walked to his cozy cave, soft and warm, and hugged his fuzzy blanket.\n\nOutside, the moon smiled down. "Goodnight, moon," whispered Little Bear.\n\nHe closed his eyes and dreamed of honey and bees. Goodnight, Little Bear.',
  ),
  Story(
    title: "Ducky's Big Splash",
    emoji: '🦆',
    gradient: const [Color(0xFF29B6F6), Color(0xFF0288D1)],
    content:
        'Ducky waddled to the pond. Splish! Splash! In he went.\n\nHe paddled his feet and wiggled his tail. "Quack, quack! Come play!" he called.\n\nFroggy hopped in — splash! Fishy swam by — splash!\n\nSoon everyone was laughing and splashing together. What a fun, wet day!',
  ),
  Story(
    title: 'The Bunny Who Loved Carrots',
    emoji: '🐰',
    gradient: const [Color(0xFFFFB74D), Color(0xFF81C784)],
    content:
        'Baby Bunny hopped through the garden. Hop, hop, hop!\n\nHe found one crunchy carrot. Then he found two!\n\nHe hopped over to his friends. "Would you like a carrot?" he asked. Squirrel said yes. Hedgehog said yes too.\n\nThey munched and crunched together. Sharing made everyone happy.',
  ),
  Story(
    title: 'Goodnight, Little Star',
    emoji: '⭐',
    gradient: const [Color(0xFF283593), Color(0xFF3949AB)],
    content:
        'One little star woke up in the sky. Twinkle, twinkle!\n\nSoon two more stars appeared. Then three, then four!\n\nThe little star counted them all. "Hello, friends!" she twinkled.\n\nTogether they lit up the night sky, watching over sleepy children below. Sweet dreams, little ones.',
  ),
  Story(
    title: "The Kitten's New Friend",
    emoji: '🐱',
    gradient: const [Color(0xFFF48FB1), Color(0xFFF06292)],
    content:
        'Kitten sat alone in the yard. Meow.\n\nThen a fluffy puppy trotted over. Woof! "Want to play?" asked Puppy.\n\nKitten smiled. They chased a red ball together. Roll, roll, roll!\n\nThey napped in the sun, curled up side by side. Kitten had a new best friend.',
  ),
  Story(
    title: 'Rainy Day Rainbow',
    emoji: '🌈',
    gradient: const [Color(0xFF26A69A), Color(0xFF4DB6AC)],
    content:
        'Pitter, patter! Rain fell on the window. "Can we still play?" asked little Mia.\n\nMama smiled. They pulled on their splashy boots. Jump! Splash! They jumped in every puddle.\n\nWhen the rain stopped, the sun peeked out.\n\nLook! A big, colorful rainbow stretched across the sky.',
  ),
  Story(
    title: "The Little Train's Big Hill",
    emoji: '🚂',
    gradient: const [Color(0xFFEF5350), Color(0xFFFFCA28)],
    content:
        'Chug, chug, chug! The little train carried toys up a tall hill.\n\nIt felt very big and very steep. "I think I can, I think I can," puffed the little train.\n\nSlowly, slowly, up he climbed. At the very top he cheered, "I knew I could!"\n\nDown the other side he zoomed, whistling happily.',
  ),
  Story(
    title: 'Three Fluffy Kittens',
    emoji: '🐈',
    gradient: const [Color(0xFFB39DDB), Color(0xFF9575CD)],
    content:
        'Three fluffy kittens loved their soft mittens.\n\nOne day, their mittens went missing! "We lost our mittens," they cried.\n\nThey looked under the bed. They looked behind the door. There they were, warm and cozy in a basket!\n\nThe three kittens put on their mittens and purred happily.',
  ),
];

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.stories,
        title: Text('Stories', style: AppTheme.heading(fontSize: 26, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            final story = stories[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StoryDetailScreen(story: story)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: story.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                        ),
                        child: Center(child: Text(story.emoji, style: const TextStyle(fontSize: 56))),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      child: Text(
                        story.title,
                        style: AppTheme.body(fontSize: 14, weight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  const StoryDetailScreen({super.key, required this.story});

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  late AudioService _audio;

  @override
  void initState() {
    super.initState();
    _audio = AudioService(context.read<ProgressService>());
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  Future<void> _startReading() async {
    await _audio.speak(widget.story.content, pitch: 1.3, rate: 0.45);
    if (!mounted) return;

    final progress = context.read<ProgressService>();
    final key = 'story_${widget.story.title}';
    if (!progress.hasPracticedToday(key)) {
      await progress.markPracticedToday(key);
      await progress.addStars('stories', 10);
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.stories,
        title: Text(story.title, style: AppTheme.heading(fontSize: 20, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: story.gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Center(child: Text(story.emoji, style: const TextStyle(fontSize: 120))),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(story.content, style: AppTheme.body(fontSize: 20), textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _startReading,
                  icon: const Icon(Icons.play_arrow),
                  style: AppTheme.pillButton(AppTheme.stories),
                  label: const Text('Start Reading'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _audio.stopSpeaking,
                  icon: const Icon(Icons.stop),
                  style: AppTheme.pillButton(Colors.redAccent),
                  label: const Text('Stop Reading'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
