import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/club_model.dart';
import '../providers/club_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_padding.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_bottom_nav.dart';
import '../utils/club_utils.dart';

class ClubPage extends StatefulWidget {
  const ClubPage({super.key});

  @override
  State<ClubPage> createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = "";
  String selectedFilter = "Alphabetical";

  final List<String> filterOptions = [
    'Alphabetical',
    'Popularity',
    'Saved Clubs',
    'Career',
    'Sport',
    'Music',
  ];

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

  @override
  Widget build(BuildContext context) {
    final clubProvider = Provider.of<ClubProvider>(context);
    final filteredClubs = clubProvider.getFilteredClubs(
      searchText: searchText,
      filter: selectedFilter,
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: const Text('Clubs', style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: AppPadding.pagePadding,
        child: Column(
          children: [
            // Search bar
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Kulüp ara...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            // Filter indicator
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    'Görüntüleme: $selectedFilter',
                    style: AppTextStyles.subHeader,
                  ),
                  if (searchText.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    const Text('•'),
                    const SizedBox(width: 10),
                    Text(
                      'Arama: "$searchText"',
                      style: AppTextStyles.subHeader,
                    ),
                  ],
                ],
              ),
            ),
            // Club list
            if (clubProvider.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (filteredClubs.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Kulüp bulunamadı'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredClubs.length,
                  itemBuilder: (context, index) {
                    final club = filteredClubs[index];
                    return _buildClubCard(context, club);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubCard(BuildContext context, Club club) {
    final clubProvider = Provider.of<ClubProvider>(context, listen: false);
    
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
                  color: getClubColor(club.id),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                alignment: Alignment.center,
                child: Text(
                  club.id.toUpperCase(), // shows "EIK", "CSS", etc.
                  style: AppTextStyles.header.copyWith(color: Colors.white, fontSize: 36),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(club.name, style: AppTextStyles.cardTitle),
                        const SizedBox(height: 4),
                        Text(
                          club.type.toUpperCase(),
                          style: AppTextStyles.categoryText,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      club.saved ? Icons.bookmark : Icons.bookmark_border,
                      color: club.saved ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      clubProvider.toggleSaveClub(club.id);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}