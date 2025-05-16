import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../widgets/custom_bottom_nav.dart';
import 'event_details_page.dart';
import 'add_event_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  String selectedFilter = "Likes";
  
  final List<String> filterOptions = [
    'Likes',
    'Alphabetical',
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Add text field listener
    _searchController.addListener(() {
      setState(() {
        searchText = _searchController.text;
      });
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Event> getFilteredEvents(List<Event> events) {
    // First filter by search text
    var filtered = events.where((event) => 
      searchText.isEmpty || 
      event.title.toLowerCase().contains(searchText.toLowerCase()) ||
      event.organizer.toLowerCase().contains(searchText.toLowerCase()) ||
      event.description.toLowerCase().contains(searchText.toLowerCase())
    ).toList();
    
    // Then sort according to selected filter
    if (selectedFilter == 'Likes') {
      filtered.sort((a, b) => b.likeCount.compareTo(a.likeCount));
    } else if (selectedFilter == 'Alphabetical') {
      filtered.sort((a, b) => a.title.compareTo(b.title));
    }
    
    return filtered;
  }

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
    
    final filteredClubEvents = getFilteredEvents(eventProvider.clubEvents);
    final filteredNonClubEvents = getFilteredEvents(eventProvider.nonClubEvents);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text("Explore", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onSelected: (String value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return filterOptions.map((String option) {
                return PopupMenuItem<String>(
                  value: option,
                  child: Row(
                    children: [
                      selectedFilter == option
                          ? const Icon(Icons.check, color: Colors.amber)
                          : const SizedBox(width: 24),
                      const SizedBox(width: 10),
                      Text(option),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search, color: Colors.black, size: 24),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(fontSize: 16),
                                decoration: const InputDecoration(
                                  hintText: 'Search for events...',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Filter indicator
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Text(
                              'Sort: $selectedFilter',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            if (searchText.isNotEmpty) ...[
                              const SizedBox(width: 10),
                              const Text('•', style: TextStyle(color: Colors.grey)),
                              const SizedBox(width: 10),
                              Text(
                                'Search: "$searchText"',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Events lists
                      Expanded(
                        child: ListView(
                          children: [
                            const Text(
                              "University Club Events", 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (filteredClubEvents.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text("No club events available"),
                              )
                            else
                              ...filteredClubEvents.map((event) => buildEventCard(event)),
                            
                            const SizedBox(height: 24),
                            const Text(
                              "Other Events", 
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (filteredNonClubEvents.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text("No other events available"),
                              )
                            else
                              ...filteredNonClubEvents.map((event) => buildEventCard(event)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
