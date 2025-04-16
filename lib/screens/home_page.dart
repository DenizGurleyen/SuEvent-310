import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/app_text_styles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> sliderImages = const [
    'https://via.placeholder.com/300x150/0033FF/FFFFFF?text=Yüksek+Sadakat',
    'https://via.placeholder.com/300x150/9900CC/FFFFFF?text=Another+Event',
    'https://via.placeholder.com/300x150/FF0066/FFFFFF?text=Don\'t+Miss+It',
  ];

  final List<Map<String, dynamic>> events = const [
    {
      'title': 'Yüksek Sadakat',
      'type': 'Konser',
      'image': 'assets/images/yuksek_sadakat.jpg',
      'price': '1.5K',
      'rating': 4.2,
      'attendees': '7830 Std',
    },
    {
      'title': 'Graphic Talk',
      'type': 'Söyleşi',
      'image': 'https://via.placeholder.com/200x100',
      'price': '1.5K',
      'rating': 4.6,
      'attendees': '5200 Std',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryDark,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue,
        currentIndex: 2,
        onTap: (index) {
          final routes = ['/map', '/clubs', '/home', '/explore', '/profile'];
          if (ModalRoute.of(context)?.settings.name != routes[index]) {
            Navigator.pushNamed(context, routes[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Harita'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Kulüp'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Genel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: AppPadding.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 20),
                        _buildSearchBar(),
                        const SizedBox(height: 20),
                        _buildSlider(context),
                        const SizedBox(height: 20),
                        _buildEventList(),
                        const Spacer(), // pushes content up to leave space for bottom bar
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Merhaba, Fırat", style: AppTextStyles.header),
            Text("Hangi Etkinliklere Göz Atmak İstiyorsun", style: AppTextStyles.subHeader),
          ],
        ),
        CircleAvatar(
          backgroundColor: AppColors.lightGreen,
          child: Icon(Icons.notifications, color: AppColors.primaryDark),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.searchBarBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: 'Search for..', border: InputBorder.none),
            ),
          ),
          Icon(Icons.tune, color: Colors.grey[600]),
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        itemCount: sliderImages.length,
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primaryBlue,
                image: DecorationImage(
                  image: NetworkImage(sliderImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList() {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          final isAsset = event['image'].toString().startsWith('assets');
          return Container(
            width: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: isAsset
                      ? Image.asset(event['image'], height: 100, width: 240, fit: BoxFit.cover)
                      : Image.network(event['image'], height: 100, width: 240, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event['type'], style: AppTextStyles.categoryText),
                      Text(event['title'], style: AppTextStyles.cardTitle),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(event['price'], style: AppTextStyles.price),
                          const SizedBox(width: 6),
                          const Icon(Icons.star, color: Colors.orange, size: 16),
                          Text(event['rating'].toString(), style: AppTextStyles.rating),
                          const SizedBox(width: 6),
                          Text(event['attendees'], style: AppTextStyles.attendees),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
