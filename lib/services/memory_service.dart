import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'cloudinary_service.dart';

class MemoryService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>
      get _memories =>
          _firestore.collection('memories');

  // ==================================================
  // UPLOAD PHOTO
  // ==================================================

  static Future<String?> uploadPhoto(File file) async {
    try {
      // Upload photo to Cloudinary
      final String? imageUrl =
          await CloudinaryService.uploadFile(file);

      if (imageUrl == null || imageUrl.isEmpty) {
        return null;
      }

      // Save photo information in Firestore
      final DocumentReference<Map<String, dynamic>> document =
          await _memories.add({
        'type': 'photo',
        'url': imageUrl,
        'isFavourite': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return document.id;
    } catch (e) {
      print("MemoryService photo upload error: $e");
      return null;
    }
  }

  // ==================================================
  // UPLOAD VIDEO
  // ==================================================

  static Future<String?> uploadVideo(File file) async {
    try {
      // Upload video to Cloudinary
      final String? videoUrl =
          await CloudinaryService.uploadFile(file);

      if (videoUrl == null || videoUrl.isEmpty) {
        return null;
      }

      // Save video information in Firestore
      final DocumentReference<Map<String, dynamic>> document =
          await _memories.add({
        'type': 'video',
        'url': videoUrl,
        'isFavourite': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return document.id;
    } catch (e) {
      print("MemoryService video upload error: $e");
      return null;
    }
  }

  // ==================================================
  // GET ALL MEMORIES
  // ==================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getMemories() {
    return _memories
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ==================================================
  // GET PHOTOS ONLY
  // ==================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getPhotos() {
    return _memories
        .where(
          'type',
          isEqualTo: 'photo',
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ==================================================
  // GET VIDEOS ONLY
  // ==================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getVideos() {
    return _memories
        .where(
          'type',
          isEqualTo: 'video',
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ==================================================
  // GET FAVOURITE MEMORIES
  // ==================================================

  static Stream<QuerySnapshot<Map<String, dynamic>>>
      getFavouriteMemories() {
    return _memories
        .where(
          'isFavourite',
          isEqualTo: true,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ==================================================
  // TOGGLE FAVOURITE
  // ==================================================

  static Future<void> toggleFavourite(
    String documentId,
    bool currentlyFavourite,
  ) async {
    try {
      await _memories.doc(documentId).update({
        'isFavourite': !currentlyFavourite,
      });
    } catch (e) {
      print("Toggle favourite error: $e");
    }
  }

  // ==================================================
  // DELETE MEMORY
  // ==================================================

  static Future<void> deleteMemory(
    String documentId,
  ) async {
    try {
      await _memories.doc(documentId).delete();
    } catch (e) {
      print("Delete memory error: $e");
    }
  }

  // ==================================================
  // REMOVE FROM FAVOURITES
  // ==================================================

  static Future<void> removeFromFavourite(
    String documentId,
  ) async {
    try {
      await _memories.doc(documentId).update({
        'isFavourite': false,
      });
    } catch (e) {
      print("Remove favourite error: $e");
    }
  }
}