import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pozitivity/screens/FavouritesScreen.dart';
import 'package:pozitivity/screens/LoginScreen.dart';
import 'package:pozitivity/screens/change_password_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color screenBackgroundColor = Color(0xFFF0F5F1);
    const Color primaryGreenColor = Color.fromARGB(255, 175, 202, 176);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        elevation: 0,
        title: Text(
          'Profilim',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding:
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: primaryGreenColor.withOpacity(0.2),
                    child: Icon(Icons.person,
                        size: 80, color: primaryGreenColor),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    user!.displayName ?? "Kullanıcı",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    user!.email ?? "",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesScreen()),
                  );
                },
                icon: const Icon(Icons.favorite_border,
                    color: Colors.white),
                label: const Text(
                  'Kaydedilen Olumlamalarım',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreenColor,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
              ),
            ),

            const SizedBox(height: 40),

            _buildSectionHeader(context, 'Hesap Ayarları'),

            _buildProfileOption(
              context,
              icon: Icons.lock_outline,
              text: 'Şifreyi Değiştir',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordPage(),
                  ),
                );
              },
            ),

            const Divider(height: 30),

            _buildSectionHeader(context, 'Uygulama Bilgileri'),

            _buildProfileOption(
              context,
              icon: Icons.info_outline,
              text: 'Versiyon: 1.0.0',
              showArrow: false,
              onTap: () {},
            ),

            const Divider(height: 30),

            _buildProfileOption(
              context,
              icon: Icons.logout,
              text: 'Çıkış Yap',
              color: Colors.red,
              iconColor: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15.0, top: 10.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
        Color? color,
        Color? iconColor,
        bool showArrow = true,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.grey[700]),
        title: Text(
          text,
          style: TextStyle(
            color: color ?? Colors.black87,
            fontSize: 16,
          ),
        ),
        trailing: showArrow
            ? const Icon(Icons.arrow_forward_ios,
            size: 18, color: Colors.grey)
            : null,
        onTap: onTap,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}
