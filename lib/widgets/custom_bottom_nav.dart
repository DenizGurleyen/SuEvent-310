import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routes = ['/home', '/explore', '/clubs', '/profile'];

    return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Material(
            elevation: 8,
            // No color here: each item paints its own background
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,    // enables icon‑grow animation
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: currentIndex,
              onTap: (index) {
                final targetRoute = routes[index];
                if (ModalRoute.of(context)?.settings.name != targetRoute) {
                  Navigator.pushNamed(context, targetRoute);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: AppColors.primaryDark,  // per-item background
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Explore',
                  backgroundColor: AppColors.primaryDark,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Clubs',
                  backgroundColor: AppColors.primaryDark,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                  backgroundColor: AppColors.primaryDark,
                ),
              ],
            ),
        ),

        );
    }
}