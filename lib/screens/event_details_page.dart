import 'package:flutter/material.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Details"),
        automaticallyImplyLeading: true, // Sol üstte geri ok
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Event Title",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "Organized by: Club XYZ",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text(
              "This is the full event description. It includes details about the event location, time, purpose, and how students can participate or apply.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
