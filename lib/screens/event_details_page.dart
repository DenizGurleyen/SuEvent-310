import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../utils/app_colors.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;
  
  const EventDetailsPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    
    // Find the event by ID
    final event = eventProvider.events.firstWhere(
      (e) => e.id == eventId,
      orElse: () => Event(
        id: 'not-found',
        title: 'Event not found',
        organizer: '',
        description: '',
        date: DateTime.now(),
        location: '',
        isClubEvent: false,
      ),
    );
    
    // Format date
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final formattedDate = dateFormat.format(event.date);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text('Event Details', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (event.id != 'not-found')
            IconButton(
              icon: Icon(
                event.isFavorited ? Icons.star : Icons.star_border,
                color: event.isFavorited ? Colors.amber : Colors.white,
              ),
              onPressed: () {
                eventProvider.toggleEventFavorite(event.id);
              },
            ),
        ],
      ),
      body: event.id == 'not-found'
          ? const Center(child: Text('Event not found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      const Icon(Icons.group, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        "Organized by: ${event.organizer}",
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        event.location,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          eventProvider.toggleEventLike(event.id);
                        },
                        child: Row(
                          children: [
                            Icon(
                              event.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                              color: event.isLiked ? Colors.blue : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              event.likeCount.toString(),
                              style: TextStyle(
                                color: event.isLiked ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  const Text(
                    "About this event",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
