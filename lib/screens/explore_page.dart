import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';

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
      bool liked = events[index]['liked'];
      events[index]['liked'] = !liked;
      events[index]['likes'] += liked ? -1 : 1;
    });
  }

  void toggleFavorite(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['favorited'] = !events[index]['favorited'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      appBar: AppBar(
        title: const Text("Explore"),
        automaticallyImplyLeading: false, // Sol üstteki geri tuşunu kaldırır
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("University Club Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(universityEvents.length, (index) {
              return buildEventCard(universityEvents[index], true, index);
            }),
            const SizedBox(height: 24),
            const Text("Other Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(otherEvents.length, (index) {
              return buildEventCard(otherEvents[index], false, index);
            }),
          ],
        ),
      ),
    );
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isClubEvent, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            event['favorited'] ? Icons.star : Icons.star_border,
            color: event['favorited'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            if (isClubEvent) {
              toggleFavorite(universityEvents, index);
            } else {
              toggleFavorite(otherEvents, index);
            }
          },
        ),
        title: Text(event['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text(isClubEvent ? event['club'] : event['organizer']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event['liked'] ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: event['liked'] ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                if (isClubEvent) {
                  toggleLike(universityEvents, index);
                } else {
                  toggleLike(otherEvents, index);
                }
              },
            ),
            Text(event['likes'].toString()),
          ],
        ),
      ),
    );
  }
}
