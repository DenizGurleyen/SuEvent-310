import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_bottom_nav.dart';
import '../models/event_model.dart';
import 'event_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentSliderPage = 0;

  final List<String> sliderImages = const [
    'https://picsum.photos/id/1015/300/150',
    'https://picsum.photos/id/1016/300/150',
    'https://picsum.photos/id/1018/300/150',
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
      'image': 'https://images.unsplash.com/photo-1742943892627-f7e4ddf91224?q=80&w=3269&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'price': '1.5K',
      'rating': 4.6,
      'attendees': '5200 Std',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
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
                        _buildHeader(context),
                        const SizedBox(height: 20),
                        _buildSlider(context),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "YAKLAŞAN BÜYÜK ETKİNLİKLER",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
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

  Widget _buildHeader(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    // First try to get the display name directly from auth provider's user
    String userName = 'Sabancılı';
    
    if (user != null) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        userName = user.displayName!;
        print('HomePage: Using displayName: $userName');
      } else if (user.email != null && user.email!.isNotEmpty) {
        print('HomePage: Using email-derived name: $userName');
      }
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Merhaba, $userName", style: AppTextStyles.header),
            Text("Hangi Etkinliklere Göz Atmak İstiyorsun", style: AppTextStyles.subHeader),
          ],
        ),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.lightGreen,
              child: Icon(Icons.notifications, color: AppColors.primaryDark),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black, size: 24),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Search for..',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF1E6FFF), // same blue as your design
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          )
        ],
      ),
    );
  }

  Widget _buildSlider(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final topEvents = eventProvider.topEvents;
    
    if (eventProvider.isLoading) {
      return Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    // If no events, show placeholder
    if (topEvents.isEmpty) {
      return Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'Henüz etkinlik yok',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: topEvents.length,
              onPageChanged: (index) {
                setState(() {
                  _currentSliderPage = index;
                });
              },
              itemBuilder: (context, index) {
                final event = topEvents[index];
                final formattedDate = DateFormat('dd MMMM yyyy').format(event.date);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsPage(eventId: event.id),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedDate.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.thumb_up, color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${event.likeCount} beğeni',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(topEvents.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentSliderPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentSliderPage == index ? Colors.amber : Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return SizedBox(
      height: 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        separatorBuilder: (context, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final event = events[index];
          final isAsset = event['image'].toString().startsWith('assets');
          return Container(
            width: 270,
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
                      ? Image.asset(event['image'], height: 150, width: 270, fit: BoxFit.cover)
                      : Image.network(event['image'], height: 150, width: 270, fit: BoxFit.cover),
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
