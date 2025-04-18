import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // Dummy saved activities data (can be reused from HomePage)
  final List<Map<String, dynamic>> savedActivities = const [
    {
      'title': 'Yüksek Sadakat',
      'type': 'Konser',
      'image': 'assets/images/yuksek_sadakat.jpg',
      'date': '2025-04-25',
      'price': '1.5K',
      'rating': 4.2,
      'attendees': '7830 Std',
      'description': 'Rock concert at university hall',
    },
    {
      'title': 'Graphic Talk',
      'type': 'Söyleşi',
      'image': 'https://via.placeholder.com/200x100',
      'date': '2025-05-03',
      'price': '1.5K',
      'rating': 4.6,
      'attendees': '5200 Std',
      'description': 'Design trends and future talks',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: AppColors.primaryDark,
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            Text("Kaydedilen Etkinlikler", style: AppTextStyles.header),
            const SizedBox(height: 10),
            Expanded(child: _buildSavedActivitiesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fırat Yılmaz", style: AppTextStyles.cardTitle),
              Text("firat@mail.com", style: AppTextStyles.subHeader),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile/settings');
                },
                child: const Text("Profili Düzenle"),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSavedActivitiesList() {
    return ListView.builder(
      itemCount: savedActivities.length,
      itemBuilder: (context, index) {
        final activity = savedActivities[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            onTap: () {
              _showEventDetails(context, savedActivities[index]);
            },
            title: Text(activity['title'], style: AppTextStyles.cardTitle),
            subtitle: Text("${activity['date']} • ${activity['description']}"),
            leading: const Icon(Icons.event),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Safely extract values with fallbacks
        final String title = event['title'] ?? 'Etkinlik';
        final String type = event['type'] ?? 'Etkinlik Türü';
        final String image = event['image'] ?? '';
        final String date = event['date'] ?? 'Tarih Bilinmiyor';
        final String price = event['price'] ?? 'Fiyat Bilinmiyor';
        final double rating = (event['rating'] ?? 0).toDouble();
        final String attendees = event['attendees'] ?? '0';
        final String description = event['description'] ?? 'Açıklama yok';

        final bool isAsset = image.startsWith('assets');

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.65,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isAsset
                              ? Image.asset(image, height: 180, width: double.infinity, fit: BoxFit.cover)
                              : Image.network(image, height: 180, width: double.infinity, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 16),
                        Text(title, style: AppTextStyles.header),
                        const SizedBox(height: 8),
                        Text("Tür: $type", style: AppTextStyles.subHeader),
                        const SizedBox(height: 4),
                        Text("Tarih: $date", style: AppTextStyles.subHeader),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text("Fiyat: $price", style: AppTextStyles.price),
                            const SizedBox(width: 12),
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            Text(rating.toString(), style: AppTextStyles.rating),
                            const SizedBox(width: 12),
                            Icon(Icons.people, size: 16, color: Colors.grey[700]),
                            const SizedBox(width: 4),
                            Text(attendees, style: AppTextStyles.attendees),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text("Açıklama:", style: AppTextStyles.cardTitle),
                        const SizedBox(height: 6),
                        Text(description, style: AppTextStyles.subHeader),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            // You can show a SnackBar just for the demo
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Etkinlik kayıttan kaldırıldı.")),
                            );
                          },
                          icon: const Icon(Icons.bookmark_remove),
                          label: const Text("Kaydedilenlerden Çıkar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
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
}
