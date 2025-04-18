import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';
import '../utils/app_colors.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final TextEditingController nameController = TextEditingController(text: "Fırat Yılmaz");
  final TextEditingController emailController = TextEditingController(text: "firat@mail.com");

  String profileImageUrl = 'https://via.placeholder.com/150';

  void _changeProfilePicture() {
    // For now, simulate changing the picture
    setState(() {
      profileImageUrl = 'https://via.placeholder.com/150/FF0066/FFFFFF?text=Updated';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil fotoğrafı güncellendi!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Profili Düzenle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _changeProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // In a real app, you'd save this data somewhere
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil bilgileri kaydedildi.")),
                );
              },
              child: const Text("Kaydet"),
            )
          ],
        ),
      ),
    );
  }
}
