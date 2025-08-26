import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class FirestoreUserService {
  // Kullanıcıyı Firestore'a ekle (kayıt sırasında)
  static Future<void> addUserToFirestore(User user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'balance': 0, // Başlangıç bakiyesi
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Kullanıcı Firestore\'a eklendi: ${user.email}');
    } catch (e) {
      print('Kullanıcı ekleme hatası: $e');
      throw e;
    }
  }

  // Kullanıcı verilerini çek
  static Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }

  // Kullanıcının bakiyesini güncelle
  static Future<void> updateBalance(double amount) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'balance': FieldValue.increment(amount),
      });
    }
  }
}
