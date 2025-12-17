import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> addToFavorites(String text, String category) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "testUser";

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc();

    await docRef.set({
      'text': text,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print('Favorilere eklendi!');
  } catch (e) {
    print('Favori eklenirken hata: $e');
  }
}
