import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Events App',
      debugShowCheckedModeBanner: false,
      home: const EventsScreen(),
    );
  }
}

// ------------------ EVENTS SCREEN ------------------

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<Map<String, dynamic>> universityEvents = [
    {'title': 'CompTalks', 'club': 'IEEE', 'likes': 230, 'liked': false, 'favorited': false},
    {'title': 'IMIS’25', 'club': 'IES', 'likes': 115, 'liked': false, 'favorited': false},
    {'title': 'Last Dance', 'club': 'SUDance', 'likes': 88, 'liked': false, 'favorited': false},
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text("University Club Events", style: AppTextStyles.header),
              const SizedBox(height: 10),
              ...List.generate(
                universityEvents.length,
                    (index) => _buildEventTile(context, universityEvents, index, isClubEvent: true),
              ),
              const SizedBox(height: 20),
              const Text("Other Events", style: AppTextStyles.header),
              const SizedBox(height: 10),
              ...List.generate(
                otherEvents.length,
                    (index) => _buildEventTile(context, otherEvents, index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventTile(
      BuildContext context,
      List<Map<String, dynamic>> events,
      int index, {
        bool isClubEvent = false,
      }) {
    final event = events[index];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            event['favorited'] ? Icons.star : Icons.star_border,
            color: event['favorited'] ? Colors.amber : Colors.grey,
          ),
          onPressed: () => toggleFavorite(events, index),
        ),
        title: Text(event['title'], style: AppTextStyles.cardTitle),
        subtitle: Text(isClubEvent ? event['club'] : event['organizer']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event['liked'] ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: event['liked'] ? Colors.blue : Colors.grey,
                size: 20,
              ),
              onPressed: () => toggleLike(events, index),
            ),
            Text(event['likes'].toString()),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(
                title: event['title'],
                description: "Etkinlik detayları burada yer alacak.",
                clubOrOrganizer: isClubEvent ? event['club'] : event['organizer'],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ------------------ EVENT DETAILS SCREEN ------------------

class EventDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String clubOrOrganizer;

  const EventDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.clubOrOrganizer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.header),
              const Divider(thickness: 1, height: 24),
              Text(description),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Icon(Icons.apartment_outlined, size: 24),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(clubOrOrganizer, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const Text("Sabancı Üniversitesi", style: TextStyle(color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ BOTTOM NAV ------------------

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // navigate logic
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.location_on), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.access_time), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
      ],
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}

// ------------------ STYLES ------------------

class AppTextStyles {
  static const header = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
  static const cardTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
}
