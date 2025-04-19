import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'event_details_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> universityEvents = [
    {'title': 'CompTalks', 'club': 'IEEE', 'likes': 250, 'liked': false},
    {'title': 'IMES25', 'club': 'IES', 'likes': 115, 'liked': false},
    {'title': 'Last Dance', 'club': 'SUDance', 'likes': 60, 'liked': false},
  ];

  final List<Map<String, dynamic>> otherEvents = [
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 22, 'liked': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false},
  ];

  void toggleLike(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['liked'] = !(events[index]['liked'] ?? false);
      events[index]['likes'] += events[index]['liked'] ? 1 : -1;
    });
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isUniversity, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventDetailsPage()),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 2,
        child: ListTile(
          leading: Icon(
            Icons.star,
            color: event['liked'] ? Colors.orange : Colors.grey,
          ),
          title: Text(event['title']),
          subtitle: Text(isUniversity ? 'Club: ${event['club']}' : 'Organizer: ${event['organizer']}'),
          trailing: GestureDetector(
            onTap: () => toggleLike(isUniversity ? universityEvents : otherEvents, index),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(event['likes'].toString()),
                const SizedBox(width: 4),
                const Icon(Icons.favorite_border),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text('Explore', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
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
}
