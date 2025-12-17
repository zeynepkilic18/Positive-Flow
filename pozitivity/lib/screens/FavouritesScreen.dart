import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pozitivity/card/FavouritesCard.dart';

const Map<String, Color> categoryColors = {
  'Kendine Güven': Color(0xFFF7C351),
  'Başarı ve Kariyer': Color(0xFFE56A6A),
  'Huzur ve Rahatlama': Color(0xFF5ABF77),
  'Aşk & İlişkiler': Color(0xFFE788A8),
  'Sağlık ve Zindelik': Color(0xFF9B59B6),
  'Yaratıcılık ve İlham': Color(0xFFF1C40F),
};

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteAffirmations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "testUser";
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .orderBy('timestamp', descending: true)
          .get();

      final favorites = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'text': doc['text'],
          'categoryName': doc['category'],
        };
      }).toList();

      setState(() {
        favoriteAffirmations = favorites;
      });
    } catch (e) {
      print('Favoriler alınırken hata: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> removeFavorite(String docId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? "testUser";
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Favoriden silindi!")),
      );

      // Listeyi güncelle
      fetchFavorites();
    } catch (e) {
      print('Favori silinirken hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silme işlemi başarısız!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color screenBackgroundColor = Color(0xFFF0F5F1);

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Favorilerim',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteAffirmations.isEmpty
          ? const Center(child: Text("Henüz favorilere eklenmiş olumlama yok."))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        itemCount: favoriteAffirmations.length,
        itemBuilder: (context, index) {
          final item = favoriteAffirmations[index];
          final String categoryName = item['categoryName'] as String;
          final Color baseColor = categoryColors[categoryName] ?? Colors.grey;

          return Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: FavoriteCard(
              affirmation: item['text'] as String,
              categoryBaseColor: baseColor,
              onDelete: () => removeFavorite(item['id']), // 🔹 Silme fonksiyonu
            ),
          );
        },
      ),
    );
  }
}
