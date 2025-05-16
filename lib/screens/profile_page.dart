import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/club_model.dart';
import '../models/event_model.dart';
import '../providers/auth_provider.dart';
import '../providers/club_provider.dart';
import '../providers/event_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../utils/club_utils.dart';
import '../widgets/custom_bottom_nav.dart';
import 'event_details_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context, user?.email),
            const SizedBox(height: 20),
            _buildSavedClubsSection(context),
            const SizedBox(height: 20),
            _buildSavedActivitiesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String? email) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/75.jpg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fırat Yılmaz", style: AppTextStyles.cardTitle),
              Text(email ?? "firat@mail.com", style: AppTextStyles.subHeader),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile/settings');
                },
                child: const Text("Profili Düzenle"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSavedClubsSection(BuildContext context) {
    final clubProvider = Provider.of<ClubProvider>(context);
    final savedClubs = clubProvider.savedClubs;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Kaydedilen Kulüpler", style: AppTextStyles.header),
        const SizedBox(height: 10),
        if (clubProvider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (savedClubs.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text("Kaydedilmiş kulüp bulunamadı"),
            ),
          )
        else
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: savedClubs.length,
              itemBuilder: (context, index) {
                final club = savedClubs[index];
                return _buildSavedClubCard(context, club);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSavedClubCard(BuildContext context, Club club) {
    final clubProvider = Provider.of<ClubProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => _showClubDetails(context, club),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: getClubColor(club.id),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                alignment: Alignment.center,
                child: Text(
                  club.id.toUpperCase(),
                  style: AppTextStyles.header.copyWith(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        club.name,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => clubProvider.toggleSaveClub(club.id),
                      child: const Icon(
                        Icons.bookmark,
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClubDetails(BuildContext context, Club club) {
    final clubProvider = Provider.of<ClubProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: getClubColor(club.id),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            club.name,
                            style: AppTextStyles.header.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(club.name, style: AppTextStyles.header),
                            ),
                            IconButton(
                              icon: Icon(
                                club.saved ? Icons.bookmark : Icons.bookmark_border,
                                color: club.saved ? Colors.amber : Colors.grey,
                              ),
                              onPressed: () {
                                clubProvider.toggleSaveClub(club.id);
                                // Close the modal after removing from saved
                                if (club.saved) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(club.description, style: AppTextStyles.subHeader),
                        const SizedBox(height: 16),
                        Text("Etkinlik Türleri:", style: AppTextStyles.cardTitle),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: List<Widget>.from(
                            club.events.map((event) => Chip(label: Text(event))),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Yaklaşan Etkinlik", style: AppTextStyles.cardTitle),
                        const SizedBox(height: 6),
                        Text("Henüz açıklanmadı", style: AppTextStyles.subHeader),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSavedActivitiesSection(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final favoritedEvents = eventProvider.favoritedEvents;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Kaydedilen Etkinlikler", style: AppTextStyles.header),
        const SizedBox(height: 10),
        
        if (eventProvider.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (favoritedEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text("Kaydedilmiş etkinlik bulunamadı"),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favoritedEvents.length,
            itemBuilder: (context, index) {
              final event = favoritedEvents[index];
              final formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
              
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(event.title, style: AppTextStyles.cardTitle),
                  subtitle: Text("$formattedDate • ${event.organizer}"),
                  trailing: const Icon(Icons.chevron_right),
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
            },
          ),
      ],
    );
  }
}
