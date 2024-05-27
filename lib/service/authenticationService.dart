import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // Firebase ile giriş yapma
  Future<String> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser!.uid; // Başarılı giriş
    } catch (e) {
      return "null"; // Hata mesajı döndür
    }
  }

  String getCurrentUID() {
    return _auth.currentUser!.uid;
  }

  // Firebase ile kaydolma
  Future signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null; // Başarılı kayıt
    } catch (e) {
      return e.toString(); // Hata mesajı döndür
    }
  }

  // Firebase ile çıkış yapma
  Future signOut() async {
    await _auth.signOut();
  }

  CollectionReference getCollection(String collectionName) {
    return db.collection(collectionName);
  }

  Future<List<String>> listCollections(String collectionName) async {
    List<String> collections = [];
    try {
      QuerySnapshot snapshot = await getCollection(collectionName).get();
      for (var doc in snapshot.docs) {
        collections.add(doc.id);
      }
    } catch (e) {
      print(e.toString());
    }
    return collections;
  }

  Future<String> registerFirebase(
      String collection, Map<String, String> fieldValue) async {
    if (fieldValue.containsKey('id') && fieldValue.containsKey('password')) {
      try {
        await _auth.createUserWithEmailAndPassword(
            email: "${fieldValue['id']!}@mail.com",
            password: fieldValue['password']!);

        await db
            .collection(collection)
            .doc(_auth.currentUser!.uid)
            .set(fieldValue);

        return 'success';
      } catch (e) {
        return e.toString();
      }
    }
    return "id or password is required";
  }

  // Kullanıcının oturum durumunu kontrol etme
  Stream<User?> Function() get user => _auth.authStateChanges;
}
