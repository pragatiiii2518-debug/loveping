import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //--------------------------------------------------
  // CREATE USER
  //--------------------------------------------------

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String loveId,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "uid": uid,
      "name": name,
      "email": email,
      "loveId": loveId,
      "partnerId": "",
      "profileImage": "",
      "hearts": 0,
      "streak": 0,
      "letters": 0,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  //--------------------------------------------------
  // GET USER DOCUMENT
  //--------------------------------------------------

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection("users").doc(uid).get();
  }

  //--------------------------------------------------
  // GET USER DATA (Map)
  //--------------------------------------------------

  Future<Map<String, dynamic>> getUserData(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }

    return {};
  }

  //--------------------------------------------------
  // UPDATE USER
  //--------------------------------------------------

  Future<void> updateUserData(
      String uid, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(uid).update(data);
  }

  //--------------------------------------------------
  // CONNECT PARTNER
  //--------------------------------------------------

  Future<bool> connectPartner({
    required String myUid,
    required String partnerLoveId,
  }) async {
    final query = await _firestore
        .collection("users")
        .where("loveId", isEqualTo: partnerLoveId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return false;
    }

    final partner = query.docs.first;

    await _firestore.collection("users").doc(myUid).update({
      "partnerId": partner.id,
    });

    await _firestore.collection("users").doc(partner.id).update({
      "partnerId": myUid,
    });

    return true;
  }
}