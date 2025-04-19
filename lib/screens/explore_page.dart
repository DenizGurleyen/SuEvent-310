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
    {'title': 'CompTalks', 'club': 'IEEE', 'likes': 250, 'liked': false, 'favorited': false},
    {'title': 'IMES25', 'club': 'IES', 'likes': 115, 'liked': false, 'favorited': false},
    {'title': 'Last Dance', 'club': 'SUDance', 'likes': 60, 'liked': false, 'favorited': false},
  ];

  final List<Map<String, dynamic>> otherEvents = [
    {'title': 'Chess Tournament', 'organizer': 'Ahmet Mehmet', 'likes': 24, 'liked': false, 'favorited': false},
    {'title': 'Lake Party', 'organizer': 'Ali Veli', 'likes': 5, 'liked': false, 'favorited': false},
  ];

  void toggleLike(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['liked'] = !(events[index]['liked'] ?? false);
      events[index]['likes'] += events[index]['liked'] ? 1 : -1;
    });
  }

  void toggleFavorite(List<Map<String, dynamic>> events, int index) {
    setState(() {
      events[index]['favorited'] = !(events[index]['favorited'] ?? false);
    });
  }

  Widget buildEventCard(Map<String, dynamic> event, bool isClubEvent, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            event['favorited'] ? Icons.star : Icons.star_border,
            color: event['favorited'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () => toggleFavorite(
              isClubEvent ? universityEvents : otherEvents, index),
        ),
        title: Text(event['title']),
        subtitle: Text(isClubEvent
            ? 'Club: ${event['club']}'
            : 'Organizer: ${event['organizer']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event['liked'] ? Icons.favorite : Icons.favorite_border,
                color: event['liked'] ? Colors.red : Colors.grey,
              ),
              onPressed: () => toggleLike(
                  isClubEvent ? universityEvents : otherEvents, index),
            ),
            Text('${event['likes']}'),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EventDetailsPage(),
            ),
          );
        },
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
            const Text(
              "University Club Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...List.generate(
              universityEvents.length,
                  (index) => buildEventCard(universityEvents[index], true, index),
            ),
            const SizedBox(height: 24),
            const Text(
              "Other Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...List.generate(
              otherEvents.length,
                  (index) => buildEventCard(otherEvents[index], false, index),
            ),
          ],
        ),
      ),
    );
  }
}
