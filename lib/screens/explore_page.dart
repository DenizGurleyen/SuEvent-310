import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_bottom_nav.dart';
import 'event_details_page.dart';
import 'add_event_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  Widget buildEventCard(Event event) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            event.isFavorited ? Icons.star : Icons.star_border,
            color: event.isFavorited ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            eventProvider.toggleEventFavorite(event.id);
          },
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(event.organizer),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                event.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: event.isLiked ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                eventProvider.toggleEventLike(event.id);
              },
            ),
            Text(event.likeCount.toString()),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsPage(eventId: event.id),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text("Explore", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventPage()),
          );
        },
        backgroundColor: AppColors.primaryDark,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
      body: eventProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventProvider.error != null
              ? Center(child: Text("Error: ${eventProvider.error}"))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      const Text(
                        "University Club Events", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (eventProvider.clubEvents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("No club events available"),
                        )
                      else
                        ...eventProvider.clubEvents.map((event) => buildEventCard(event)),
                      
                      const SizedBox(height: 24),
                      const Text(
                        "Other Events", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (eventProvider.nonClubEvents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("No other events available"),
                        )
                      else
                        ...eventProvider.nonClubEvents.map((event) => buildEventCard(event)),
                    ],
                  ),
                ),
    );
  }
}
