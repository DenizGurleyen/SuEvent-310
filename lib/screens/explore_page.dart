import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> universityEvents = [
    {'title': 'CompTalks', 'club': 'IEEE', 'likes': 250, 'liked': false, 'favorited': false},
    {'title': 'IMIS\'25', 'club': 'IES', 'likes': 115, 'liked': false, 'favorited': false},
    {'title': 'Last Dance', 'club': 'SUDance', 'likes': 60, 'liked': false, 'favorited': false},
  ];

  final List<Map<String, dynamic>> otherEvents = [
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 24, 'liked': false, 'favorited': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false, 'favorited': false},
  ];

  void toggleLike(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['liked'] = !(events[index]['liked'] as bool);
      if (events[index]['liked']) {
        events[index]['likes'] += 1;
      } else {
        events[index]['likes'] -= 1;
      }
    });
  }

  void toggleFavorite(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['favorited'] = !(events[index]['favorited'] as bool);
    });
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isClubEvent, int index, List<Map<String, dynamic>> eventsList) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            event['favorited'] ? Icons.star : Icons.star_border,
            color: event['favorited'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () => toggleFavorite(eventsList, index),
        ),
        title: Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(isClubEvent ? event['club'] : event['organizer']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event['liked'] ? Icons.favorite : Icons.favorite_border,
                color: event['liked'] ? Colors.red : Colors.grey,
              ),
              onPressed: () => toggleLike(eventsList, index),
            ),
            Text(event['likes'].toString()),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore"),
        leading: Navigator.of(context).canPop()
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("University Club Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(universityEvents.length,
                    (index) => buildEventCard(universityEvents[index], true, index, universityEvents)),
            const SizedBox(height: 24),
            const Text("Other Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(otherEvents.length,
                    (index) => buildEventCard(otherEvents[index], false, index, otherEvents)),
          ],
        ),
      ),
    );
  }
}
