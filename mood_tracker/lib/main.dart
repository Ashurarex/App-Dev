import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MoodTrackerApp());
}

class MoodTrackerApp extends StatelessWidget {
  const MoodTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.indigo[50],
      ),
      debugShowCheckedModeBanner: false,
      home: const MoodSelectionPage(),
    );
  }
}

/// Enum for recommendation type
enum RecommendationType { joke, quote, music }

/// First Screen — Mood Selection
class MoodSelectionPage extends StatefulWidget {
  const MoodSelectionPage({Key? key}) : super(key: key);

  @override
  State<MoodSelectionPage> createState() => _MoodSelectionPageState();
}

class _MoodSelectionPageState extends State<MoodSelectionPage> {
  final List<Map<String, dynamic>> moods = [
    {'name': 'Happy', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.orange},
    {'name': 'Sad', 'icon': Icons.sentiment_dissatisfied, 'color': Colors.blue},
    {'name': 'Excited', 'icon': Icons.emoji_events, 'color': Colors.purple},
    {'name': 'Stressed', 'icon': Icons.mood_bad, 'color': Colors.red},
    {'name': 'Relaxed', 'icon': Icons.self_improvement, 'color': Colors.green},
    {'name': 'Motivated', 'icon': Icons.flash_on, 'color': Colors.amber},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling today?'),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: moods.map((m) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecommendationPage(selectedMood: m['name']),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 6,
                color: (m['color'] as Color).withOpacity(0.85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(m['icon'] as IconData, size: 60, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      m['name'] as String,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Second Screen — Recommendations
class RecommendationPage extends StatefulWidget {
  final String selectedMood;
  const RecommendationPage({Key? key, required this.selectedMood}) : super(key: key);

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  RecommendationType? selectedRecType;
  String resultTitle = '';
  String resultContent = '';
  bool isLoading = false;
  String error = '';

  Future<void> fetchRecommendation() async {
    if (selectedRecType == null) return;

    setState(() {
      isLoading = true;
      error = '';
      resultTitle = '';
      resultContent = '';
    });

    switch (selectedRecType) {
      case RecommendationType.joke:
        await _fetchJoke();
        break;
      case RecommendationType.quote:
        await _fetchQuote();
        break;
      case RecommendationType.music:
        await _fetchMusic();
        break;
      default:
        break;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchJoke() async {
    try {
      final res = await http.get(Uri.parse('https://v2.jokeapi.dev/joke/Any'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        String jokeText = '';
        if (data['type'] == 'single') {
          jokeText = data['joke'];
        } else {
          jokeText = '${data['setup']}\n${data['delivery']}';
        }
        setState(() {
          resultTitle = 'Here’s a Joke 😂';
          resultContent = jokeText;
        });
      } else {
        setState(() => error = 'Failed to load joke.');
      }
    } catch (e) {
      setState(() => error = 'Error fetching joke.');
    }
  }

  Future<void> _fetchQuote() async {
    try {
      final res = await http.get(Uri.parse('https://zenquotes.io/api/random'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List && data.isNotEmpty) {
          final quote = data[0]['q'] ?? '';
          final author = data[0]['a'] ?? 'Unknown';
          setState(() {
            resultTitle = 'Inspirational Quote 💬';
            resultContent = '"$quote"\n\n— $author';
          });
          return;
        }
      }
      setState(() => error = 'Could not load quote.');
    } catch (e) {
      setState(() => error = 'Failed to load quote.');
    }
  }

  Future<void> _fetchMusic() async {
    final Map<String, Map<String, String>> moodMusic = {
      'Happy': {
        'title': 'Happy - Pharrell Williams',
        'link': 'https://www.youtube.com/watch?v=ZbZSe6N_BXs'
      },
      'Sad': {
        'title': 'Someone Like You - Adele',
        'link': 'https://www.youtube.com/watch?v=hLQl3WQQoQ0'
      },
      'Excited': {
        'title': 'Can’t Stop the Feeling! - Justin Timberlake',
        'link': 'https://www.youtube.com/watch?v=ru0K8uYEZWw'
      },
      'Stressed': {
        'title': 'Weightless - Marconi Union',
        'link': 'https://www.youtube.com/watch?v=UfcAVejslrU'
      },
      'Relaxed': {
        'title': 'Lo-fi Chill Playlist',
        'link': 'https://www.youtube.com/watch?v=5qap5aO4i9A'
      },
      'Motivated': {
        'title': 'Eye of the Tiger - Survivor',
        'link': 'https://www.youtube.com/watch?v=btPJPFnesV4'
      },
    };

    final music = moodMusic[widget.selectedMood];
    if (music != null) {
      setState(() {
        resultTitle = 'Music Recommendation 🎵';
        resultContent = '${music['title']}\n\nListen here:\n${music['link']}';
      });
    } else {
      setState(() {
        resultTitle = 'Music Recommendation 🎵';
        resultContent = 'No music found for this mood.';
      });
    }
  }

  Widget buildOptionButton(IconData icon, String label, RecommendationType type) {
    final isSelected = selectedRecType == type;
    return Expanded(
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.indigo : Colors.indigo[100],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: isSelected ? 6 : 2,
        ),
        onPressed: () {
          setState(() => selectedRecType = type);
          fetchRecommendation();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedMood} Mood'),
        centerTitle: true,
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Choose what you’d like:',
              style: TextStyle(
                fontSize: 22,
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                buildOptionButton(Icons.emoji_emotions, 'Joke', RecommendationType.joke),
                const SizedBox(width: 10),
                buildOptionButton(Icons.format_quote, 'Quote', RecommendationType.quote),
                const SizedBox(width: 10),
                buildOptionButton(Icons.music_note, 'Music', RecommendationType.music),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator()
                    : error.isNotEmpty
                    ? Text(error, style: const TextStyle(color: Colors.red, fontSize: 16))
                    : resultContent.isEmpty
                    ? const Text(
                  'Pick an option to get started!',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                )
                    : Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resultTitle,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          resultContent,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black87, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
