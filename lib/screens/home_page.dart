import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_bottom_nav.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

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

  final List<Map<String, String>> sliderContent = const [
  {
    'date': '20 MART 2025',
    'title': 'Yüksek Sadakat',
    'desc': 'Yüksek Sadakat, güçlü melodileri ve etkileyici sahne performanslarıyla SGM\'de!',
  },
  {
    'date': '5 NİSAN 2025',
    'title': 'Graphic Design Talk',
    'desc': 'Grafik tasarımda yaratıcılığın sınırlarını zorlayan bir etkinlik!',
  },
];

  @override
  Widget build(BuildContext context) {
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

  Widget _buildPageDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        bool isActive = index == 0; // set this dynamically if you want later
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.amber : Colors.white54,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }


  Widget _buildSlider(BuildContext context) {
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
              controller: PageController(viewportFraction: 1.0),
              itemCount: sliderContent.length,
              onPageChanged: (index) {
                // hook for indicator
              },
              itemBuilder: (context, index) {
                final item = sliderContent[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['date']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['desc']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(sliderContent.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.amber : Colors.white54,
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
