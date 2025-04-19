import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart'; // alt menü importu
import '../utils/app_colors.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> universityEvents = [
    {'title': 'CompTalks', 'club': 'IEEE', 'likes': 250, 'liked': false},
    {'title': 'IMES 25', 'club': 'IES', 'likes': 115, 'liked': false},
    {'title': 'Last Dance', 'club': 'SUDance', 'likes': 60, 'liked': false},
  ];

  final List<Map<String, dynamic>> otherEvents = [
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 23, 'liked': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false},
  ];

  void toggleLike(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['liked'] = !(events[index]['liked'] as bool);
    });
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isUniversity, int index) {
    return Card(
      child: ListTile(
        title: Text(event['title']),
        subtitle: Text(isUniversity ? event['club'] : event['organizer']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event['liked'] ? Icons.favorite : Icons.favorite_border,
                color: event['liked'] ? Colors.red : Colors.grey,
              ),
              onPressed: () => toggleLike(isUniversity ? universityEvents : otherEvents, index),
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
      appBar: AppBar(title: const Text("Explore Events")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("University Club Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(universityEvents.length, (index) => buildEventCard(universityEvents[index], true, index)),
            const SizedBox(height: 24),
            const Text("Other Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(otherEvents.length, (index) => buildEventCard(otherEvents[index], false, index)),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1), // 👈 bu satır önemli
    );
  }
}
