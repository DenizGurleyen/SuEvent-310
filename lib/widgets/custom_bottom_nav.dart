import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final routes = ['/home', '/explore', '/clubs', '/profile'];

    return BottomNavigationBar(
      backgroundColor: AppColors.primaryDark,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue,
      currentIndex: currentIndex,
      onTap: (index) {
        if (ModalRoute.of(context)?.settings.name != routes[index]) {
          Navigator.pushNamed(context, routes[index]);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Page'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Clubs'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
