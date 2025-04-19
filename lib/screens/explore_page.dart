import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> universityEvents = [
    {'title': 'CompTalks', 'club': 'IEEE', 'likes': 250, 'liked': false, 'favorited': false},
    {'title': 'IMIS’25', 'club': 'IES', 'likes': 115, 'liked': false, 'favorited': false},
    {'title': 'Last Dance', 'club': 'SUDance', 'likes': 60, 'liked': false, 'favorited': false},
  ];

  final List<Map<String, dynamic>> otherEvents = [
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 24, 'liked': false, 'favorited': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false, 'favorited': false},
  ];

  void toggleLike(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['liked'] = !events[index]['liked'];
      events[index]['likes'] += events[index]['liked'] ? 1 : -1;
    });
  }

  void toggleFavorite(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['favorited'] = !events[index]['favorited'];
    });
  }

  Widget buildEventList(String title, List<Map<String, dynamic>> events, bool isClubEvent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        ...List.generate(events.length, (index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: IconButton(
                icon: Icon(event['favorited'] ? Icons.star : Icons.star_border,
                    color: event['favorited'] ? Colors.amber : Colors.grey),
                onPressed: () => toggleFavorite(events, index),
              ),
              title: Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(isClubEvent ? event['club'] : event['organizer']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(event['liked'] ? Icons.favorite : Icons.favorite_border),
                    color: event['liked'] ? Colors.red : null,
                    onPressed: () => toggleLike(events, index),
                  ),
                  Text(event['likes'].toString()),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildEventList('University Club Events', universityEvents, true),
          buildEventList('Other Events', otherEvents, false),
        ],
      ),
    );
  }
}
