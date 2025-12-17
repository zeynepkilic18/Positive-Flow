import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pozitivity/screens/LoginScreen.dart';
import 'package:pozitivity/screens/NotificationsScreen.dart';
import 'package:pozitivity/screens/ProfileScreen.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

Widget _buildSettingsDrawer(BuildContext context) {
  const Color primaryLightColor = Color(0xFFF0F5F1);
  final user = FirebaseAuth.instance.currentUser;
  const Color primaryGreenColor = Color.fromARGB(255, 175, 202, 176);
  return Drawer(
    backgroundColor: primaryLightColor,
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            color: primaryLightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryGreenColor.withOpacity(0.2),
                  child: Icon(Icons.person, size: 50, color: primaryGreenColor),
                ),
                const SizedBox(height: 10),
                Text(
                  user?.displayName ?? "Pozitif Kullanıcı",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  user?.email ?? "example@mail.com",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profil Ayarları'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined),
                title: const Text('Bildirim Ayarları'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationSettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Hakkında'),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: "Pozitivity",
                    applicationVersion: "1.0.0",
                    applicationLegalese: "© 2025 Pozitivity",
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Uygulama Hakkında",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Bu uygulama günlük olumlamalar ile pozitif bir akış sağlamayı amaçlar.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Uygulamayı kullanarak her gün kendinize küçük pozitif hatırlatmalar bırakabilirsiniz.",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Çıkış Yap'),
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dailyAffirmation = "Yükleniyor...";
  String currentCategory = "Genel";
  bool isLoading = true;
  bool isFavorite = false;

  static const String _kSavedTextKey = 'saved_affirmation_text';
  static const String _kSavedCategoryKey = 'saved_affirmation_category';
  static const String _kSavedDateKey = 'saved_affirmation_date';

  @override
  void initState() {
    super.initState();
    _initDailyAffirmation();
  }

  Future<void> _initDailyAffirmation() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedText = prefs.getString(_kSavedTextKey);
      final savedCategory = prefs.getString(_kSavedCategoryKey);
      final savedDate = prefs.getString(_kSavedDateKey);

      final todayStr = _todayString();

      if (savedText != null && savedDate != null && savedDate == todayStr) {
        // Bugün için kayıtlı olumlama varsa
        setState(() {
          dailyAffirmation = savedText;
          currentCategory = savedCategory ?? "Genel";
        });
        await _checkIfFavorite(savedText);
      } else {
        // Yoksa
        await _fetchRandomAffirmationAndSave();
      }
    } catch (e) {
      print('initDailyAffirmation hata: $e');
      await _fetchRandomAffirmationAndSave();
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _fetchRandomAffirmationAndSave() async {
    setState(() => isLoading = true);
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('affirmations').get();

      if (snapshot.docs.isNotEmpty) {
        final rnd = Random();
        final doc = snapshot.docs[rnd.nextInt(snapshot.docs.length)];
        final text = (doc.data()['text'] ?? '').toString();
        final category = (doc.data()['category'] ?? 'Genel').toString();

        // Günün olumlaması
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_kSavedTextKey, text);
        await prefs.setString(_kSavedCategoryKey, category);
        await prefs.setString(_kSavedDateKey, _todayString());

        setState(() {
          dailyAffirmation = text;
          currentCategory = category;
        });

        await _checkIfFavorite(text);
      } else {
        setState(() {
          dailyAffirmation = "Olumlama bulunamadı.";
          currentCategory = "Genel";
          isFavorite = false;
        });
      }
    } catch (e) {
      print('fetchRandomAffirmation hata: $e');
      setState(() {
        dailyAffirmation = "Olumlama yüklenirken bir hata oluştu.";
        currentCategory = "Genel";
        isFavorite = false;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchRandomAffirmation({bool force = false}) async {
    if (force) {
      await _fetchRandomAffirmationAndSave();
    } else {
      // Normal çağrı -> init fonksiyonu zaten yararlı, ama yine de güvenlik için kontrol
      await _initDailyAffirmation();
    }
  }

  /// Favori kontrolü
  Future<void> _checkIfFavorite(String affirmation) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isFavorite = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .where('text', isEqualTo: affirmation)
          .limit(1)
          .get();

      setState(() {
        isFavorite = snapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('checkIfFavorite hata: $e');
      setState(() => isFavorite = false);
    }
  }

  /// Favoriye ekleme
  Future<void> _addToFavorites(String text, String category) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favori eklemek için giriş yapmalısın.")),
      );
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    try {
      final existsSnapshot =
      await favoritesRef.where('text', isEqualTo: text).limit(1).get();

      if (existsSnapshot.docs.isNotEmpty) {
        // Zaten var
        setState(() => isFavorite = true);
        return;
      }

      await favoritesRef.add({
        'text': text,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() => isFavorite = true);
    } catch (e) {
      print('addToFavorites hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilere eklenirken hata oluştu.")),
      );
    }
  }

  /// Favorilerden silme
  Future<void> _removeFromFavorites(String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    final favoritesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    try {
      final snapshot = await favoritesRef.where('text', isEqualTo: text).get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      setState(() => isFavorite = false);
    } catch (e) {
      print('removeFromFavorites hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favorilerden silinirken hata oluştu.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color appTitleColor = const Color.fromARGB(255, 175, 202, 176);

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildSettingsDrawer(context),
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon:
          const Icon(Icons.settings_outlined, color: Colors.grey, size: 30),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          'Pozitif Akış',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: appTitleColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon:
            const Icon(Icons.account_circle_outlined, color: Colors.grey, size: 30),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Günün Olumlaması',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black54,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 400,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: appTitleColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : SingleChildScrollView(
                          child: Text(
                            "\"$dailyAffirmation\"",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.caveat(
                              fontSize: 38,
                              color:
                              const Color.fromARGB(221, 29, 29, 29),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.redAccent.withOpacity(0.8),
                              size: 34,
                            ),
                            onPressed: () async {
                              // toggle favorite
                              if (!isFavorite) {
                                await _addToFavorites(dailyAffirmation, currentCategory);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Favorilere eklendi!")),
                                );
                              } else {
                                await _removeFromFavorites(dailyAffirmation);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Favorilerden çıkarıldı!")),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  await fetchRandomAffirmation(force: true);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.refresh, color: Colors.grey, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        'Yeni Getir',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
