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
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 23, 'liked': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false},
  ];

  void toggleFavorite(List<Map<String, dynamic>> list, int index) {
    setState(() {
      list[index]['liked'] = !(list[index]['liked'] ?? false);
    });
  }

  void goToEventDetails(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(event: event),
      ),
    );
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isUniversity, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            event['liked'] ? Icons.star : Icons.star_border,
            color: event['liked'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            toggleFavorite(isUniversity ? universityEvents : otherEvents, index);
          },
        ),
        title: Text(event['title']),
        subtitle: Text(isUniversity ? "Club: ${event['club']}" : "Organizer: ${event['organizer']}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.thumb_up, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Text("${event['likes']}"),
          ],
        ),
        onTap: () => goToEventDetails(event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryDark,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("University Club Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(universityEvents.length,
                    (index) => buildEventCard(universityEvents[index], true, index)),
            const SizedBox(height: 24),
            const Text("Other Events", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(otherEvents.length,
                    (index) => buildEventCard(otherEvents[index], false, index)),
          ],
        ),
      ),
    );
  }
}
