import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_bottom_nav.dart';
import '../utils/club_utils.dart';

// for testing something delete this commit later!!

final List<Map<String, dynamic>> dummyClubs = [
  {
    'id': 'eik',
    'name': 'Ekonomi ve İşletme Kulübü',
    'description': 'Ekonomi öğrencileri başta olmak üzere kariyer planlamasına yardımcı oluyoruz.',
    'events': ['seminerler', 'paneller', 'workshoplar', 'case studyler'],
    'type': 'career',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/University_icon.png/600px-University_icon.png',
    'saved': true,
    'popularity': 87,
  },
  {
    'id': 'ies',
    'name': 'Industrial Engineering Society',
    'description': 'Endüstri mühendisliği öğrencilerine yönelik kariyer etkinlikleri düzenliyoruz.',
    'events': ['seminerler', 'paneller', 'workshoplar', 'case studyler'],
    'type': 'career',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/University_icon.png/600px-University_icon.png',
    'saved': false,
    'popularity': 72,
  },
  {
    'id': 'sk',
    'name': 'Spor Kulübü',
    'description': 'Amerikan futbolu, basketbol ve daha fazlası.',
    'events': ['takım antrenmanları', 'yarışmalar', 'partiler'],
    'type': 'sport',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Fenerbahce_logo.svg/640px-Fenerbahce_logo.svg.png',
    'saved': true,
    'popularity': 95,
  },
  {
    'id': 'airsoft',
    'name': 'Airsoft Club',
    'description': 'Airsoft etkinlikleri düzenliyoruz.',
    'events': ['airsoft'],
    'type': 'sport',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Airsoft_gun_icon.png/512px-Airsoft_gun_icon.png',
    'saved': false,
    'popularity': 45,
  },
  {
    'id': 'kai',
    'name': 'Yapay Zeka Kulübü (KAI)',
    'description': 'Yapay zeka üzerine seminerler düzenliyoruz.',
    'events': ['seminerler'],
    'type': 'career',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Artificial_intelligence_logo.png/480px-Artificial_intelligence_logo.png',
    'saved': false,
    'popularity': 81,
  },
  {
    'id': 'css',
    'name': 'Bilgisayar Kulübü (CSS)',
    'description': 'Bilgisayar mühendisliği öğrencilerine yönelik etkinlikler.',
    'events': ['seminerler', 'workshoplar'],
    'type': 'career',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Computer_icon.png/600px-Computer_icon.png',
    'saved': true,
    'popularity': 76,
  },
  {
    'id': 'ieee',
    'name': 'Engineering Society Club (IEEE)',
    'description': 'Mühendislik öğrencilerine özel paneller ve workshoplar.',
    'events': ['seminerler', 'paneller', 'workshoplar'],
    'type': 'career',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/IEEE_logo.svg/1024px-IEEE_logo.svg.png',
    'saved': false,
    'popularity': 68,
  },
  {
    'id': 'sudosk',
    'name': 'Doğa Sporları Kulübü',
    'description': 'Tırmanış, kamp ve doğa yürüyüşleri yapıyoruz.',
    'events': ['tırmanış', 'kamp', 'hiking'],
    'type': 'sport',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Hiking_icon.png/512px-Hiking_icon.png',
    'saved': true,
    'popularity': 92,
  },
  {
    'id': 'musikus',
    'name': 'Musikus',
    'description': 'Konserler ve müzik aleti eğitimleri veriyoruz.',
    'events': ['konser', 'eğitim'],
    'type': 'music',
    'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Music-icon.png/600px-Music-icon.png',
    'saved': false,
    'popularity': 53,
  },
];


class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  String selectedFilter = "Alphabetical";

  List<Map<String, dynamic>> filteredClubs = [];

  final List<String> filterOptions = [
    'Alphabetical',
    'Popularity',
    'Saved Clubs',
    'Career',
    'Sport',
    'Music',
  ];

  void _showClubDetails(BuildContext context, Map<String, dynamic> club) {
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
                            color: getClubColor(club['id']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            club['name'],
                            style: AppTextStyles.header.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const SizedBox(height: 16),
                        Text(club['name'], style: AppTextStyles.header),
                        const SizedBox(height: 10),
                        Text(club['description'], style: AppTextStyles.subHeader),
                        const SizedBox(height: 16),
                        Text("Etkinlik Türleri:", style: AppTextStyles.cardTitle),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: List<Widget>.from(
                            club['events'].map((event) => Chip(label: Text(event))),
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


  @override
  void initState() {
    super.initState();
    filteredClubs = [...dummyClubs];
    _applyFilter();
  }

  void _applyFilter() {
    List<Map<String, dynamic>> result = [...dummyClubs];

    if (searchText.isNotEmpty) {
      result = result
          .where((club) => club['name']
          .toLowerCase()
          .contains(searchText.toLowerCase()))
          .toList();
    }

    switch (selectedFilter) {
      case 'Popularity':
        result.sort((a, b) => b['popularity'].compareTo(a['popularity']));
        break;
      case 'Saved Clubs':
        result = result.where((club) => club['saved'] == true).toList();
        result.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      case 'Career':
      case 'Sport':
      case 'Music':
        result = result.where((club) => club['type'] == selectedFilter.toLowerCase()).toList();
        result.sort((a, b) => a['name'].compareTo(b['name']));
        break;
      default:
        result.sort((a, b) => a['name'].compareTo(b['name']));
    }

    setState(() {
      filteredClubs = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text("Kulüpler"),
        elevation: 0,
      ),
      body: Padding(
        padding: AppPadding.pagePadding,
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterDropdown(),
            const SizedBox(height: 16),
            Expanded(child: _buildClubList()),
          ],
        ),
      ),
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
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                searchText = value;
                _applyFilter();
              },
              decoration: const InputDecoration(
                hintText: 'Kulüp ara...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return DropdownButton<String>(
      value: selectedFilter,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      underline: Container(height: 1, color: Colors.grey),
      items: filterOptions.map((filter) {
        return DropdownMenuItem<String>(
          value: filter,
          child: Text(filter),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedFilter = value;
            _applyFilter();
          });
        }
      },
    );
  }

  Widget _buildClubList() {
    if (filteredClubs.isEmpty) {
      return const Center(child: Text("Gösterilecek kulüp yok."));
    }

    return ListView.builder(
      itemCount: filteredClubs.length,
      itemBuilder: (context, index) {
        final club = filteredClubs[index];

        return GestureDetector(
          onTap: () {
            _showClubDetails(context, club);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: getClubColor(club['id']),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      club['id'].toUpperCase(), // shows "EIK", "CSS", etc.
                      style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 36),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        club['name'],
                        style: AppTextStyles.header,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark,
                            color: club['saved'] ? Colors.black : Colors.grey[400],
                          ),
                          onPressed: () {
                            setState(() {
                              club['saved'] = !club['saved'];
                              _applyFilter();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}