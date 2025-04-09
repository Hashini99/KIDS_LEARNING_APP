import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class Story {
  final String title;
  final String imageUrl;
  final String content;

  Story({required this.title, required this.imageUrl, required this.content});
}

class StoryScreen extends StatefulWidget {
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final FlutterTts flutterTts = FlutterTts();

  // Example list of stories
List<Story> stories = [
  Story(
    title: 'The Lion and the Mouse',
    imageUrl: 'assets/story1.png', 
    content: 'Once upon a time, a lion was asleep in the forest. A little mouse, running along, accidentally ran across the lion\'s paw. The lion woke up and grabbed the mouse with his big paws. The mouse begged the lion to let him go, promising that one day he would help the lion in return. The lion laughed but decided to let him go. Later, the lion was trapped in a hunter\'s net. The mouse heard the lion\'s roar and quickly came to help by gnawing through the ropes and setting the lion free. From that day, the lion and the mouse were the best of friends.',
  ),
  Story(
    title: 'The Tortoise and the Hare',
    imageUrl: 'assets/story1.png',
    content: 'There once was a hare who bragged about how fast he could run. He challenged the tortoise to a race. The tortoise, slow and steady, agreed to the race. The hare sped off and, thinking he had plenty of time, stopped for a nap. The tortoise kept going at a slow, steady pace. When the hare woke up, the tortoise had already crossed the finish line. The lesson: Slow and steady wins the race!',
  ),
  Story(
    title: 'The Boy Who Cried Wolf',
    imageUrl: 'assets/story1.png',
    content: 'A shepherd boy watched over a flock of sheep. One day, he cried, "Wolf! Wolf!" to get the villagers to come and help. The villagers ran to his aid, but when they arrived, they saw no wolf. The boy laughed, thinking it was funny. Later, when a wolf really appeared and the boy cried for help again, the villagers didn\'t believe him, and the wolf ate some of the sheep. The lesson: Don’t lie, or people won’t believe you when you tell the truth.',
  ),
  Story(
    title: 'The Ant and the Grasshopper',
    imageUrl: 'assets/story1.png',
    content: 'In the summer, the ant worked hard, gathering food for the winter, while the grasshopper played and sang. When winter came, the grasshopper had no food and was freezing, so he asked the ant for help. The ant replied, "I worked hard all summer. You should have done the same." The lesson: Prepare for the future and work hard.',
  ),
  Story(
    title: 'The Fox and the Grapes',
    imageUrl: 'assets/story1.png',
    content: 'A hungry fox saw a bunch of ripe grapes hanging from a vine. He tried and tried to reach them, but they were too high. Finally, he gave up and walked away saying, "Those grapes are probably sour anyway." The lesson: It\'s easy to disparage what we can\'t have.',
  ),
  Story(
    title: 'The Dog and His Reflection',
    imageUrl: 'assets/story1.png',
    content: 'A dog was carrying a bone in his mouth when he passed a pond and saw his reflection. He thought the reflection was another dog with a bigger bone, so he dropped his bone to grab the other one. But when he opened his mouth, the bone he had vanished into the water. The lesson: Don\'t be greedy.',
  ),
  Story(
    title: 'The Golden Goose',
    imageUrl: 'assets/story1.png',
    content: 'There was once a man who had a goose that laid golden eggs. Every day, the man would collect the golden eggs and sell them for money. Eventually, the man became greedy and thought, "If I cut the goose open, I can get all the gold at once." But when he did, he found no gold inside. The lesson: Greed often leads to loss.',
  ),
  Story(
    title: 'The Ugly Duckling',
    imageUrl: 'assets/story1.png',
    content: 'A young duckling was rejected by all the other animals because he was different. As he grew older, he turned into a beautiful swan. The other animals saw him and were amazed. The lesson: True beauty comes from within, and everyone grows into their own unique greatness.',
  ),
  Story(
    title: 'The Wind and the Sun',
    imageUrl: 'assets/story1.png',
    content: 'The wind and the sun argued about who was stronger. They decided to have a contest. A traveler was walking below, and the first one to make him remove his coat would win. The wind blew hard, but the traveler only held his coat tighter. The sun shone warmly, and the traveler took off his coat. The lesson: Kindness and gentleness are often stronger than force.',
  ),
  Story(
    title: 'The Farmer and the Stork',
    imageUrl: 'assets/story1.png',
    content: 'A farmer set a trap to catch the cranes that were eating his crops. One day, a stork got caught in the trap. The stork begged the farmer to let him go, saying, "I’m not a crane. I’m a stork and I’m innocent." But the farmer replied, "You’re caught with the cranes, so you’re guilty too." The lesson: You are judged by the company you keep.',
  ),
];


  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  // Initialize TTS settings
  Future<void> _initializeTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.45);
  }

  // Method to read the story text
  Future<void> _readStory(String content) async {
    if (await flutterTts.isLanguageAvailable("en-US") == true) {
      await flutterTts.speak(content);
    } else {
      print("TTS engine is not ready");
    }
  }

  // Method to stop reading
  Future<void> _stopReading() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories', style: GoogleFonts.fredoka(fontSize: 28)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to single story view
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryDetailScreen(story: stories[index]),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: Column(
                      children: [
                        Image.asset(
                          stories[index].imageUrl,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            stories[index].title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoryDetailScreen extends StatefulWidget {
  final Story story;

  StoryDetailScreen({required this.story});

  @override
  _StoryDetailScreenState createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  // Initialize TTS settings
  Future<void> _initializeTTS() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.3);
    await flutterTts.setSpeechRate(0.45);
  }

  // Method to read the story text
  Future<void> _readStory(String content) async {
    if (await flutterTts.isLanguageAvailable("en-US") == true) {
      await flutterTts.speak(content);
    } else {
      print("TTS engine is not ready");
    }
  }

  // Method to stop reading
  Future<void> _stopReading() async {
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title, style: GoogleFonts.fredoka(fontSize: 28)),
      ),
      body: SingleChildScrollView( // Wrap the body content with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              widget.story.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.story.content,
                style: GoogleFonts.comicNeue(fontSize: 22),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _readStory(widget.story.content),
                  child: Text('Start Reading'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopReading,
                  child: Text('Stop Reading'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
