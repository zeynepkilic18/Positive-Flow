import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> removeFromFavorites(String affirmationText) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final favoritesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites');

  try {
    final snapshot = await favoritesRef.where('text', isEqualTo: affirmationText).get();

    for (var doc in snapshot.docs) {
      await favoritesRef.doc(doc.id).delete();
    }
  } catch (e) {
    print("Favorilerden çıkarma hatası: $e");
  }
}
