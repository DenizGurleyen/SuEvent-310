import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
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
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 20, 'liked': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false},
  ];

  void toggleLike(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['liked'] = !(events[index]['liked'] as bool);
      events[index]['likes'] += events[index]['liked'] ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text("Explore", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("University Club Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(
              universityEvents.length,
                  (index) => buildEventCard(universityEvents[index], true, index),
            ),
            const SizedBox(height: 24),
            const Text("Other Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(
              otherEvents.length,
                  (index) => buildEventCard(otherEvents[index], false, index),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isClubEvent, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(isClubEvent ? Icons.star : Icons.event),
        title: Text(event['title']),
        subtitle: Text(isClubEvent ? 'Club: ${event['club']}' : 'Organizer: ${event['organizer']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(event['liked'] ? Icons.favorite : Icons.favorite_border),
              color: event['liked'] ? Colors.red : null,
              onPressed: () => toggleLike(isClubEvent ? universityEvents : otherEvents, index),
            ),
            Text(event['likes'].toString()),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/eventDetails');
        },
      ),
    );
  }
}
