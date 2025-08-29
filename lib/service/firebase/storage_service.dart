import 'dart:io';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageFirebaseService {
  Future<bool> uploadDataArchive(
      String userId, String url, String content) async {
    String formattedDate =
    DateFormat('HH.mm dd-MM-yyyy').format(DateTime.now());
    try {
      // Membuat data arsip baru
      Map<String, dynamic> newArchive = {
        "image_url": url,
        "content": content,
        "created_at": formattedDate,
      };

      // Menambahkan arsip baru ke dalam array 'arsip' di dokumen pengguna
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'archive': FieldValue.arrayUnion([newArchive]),
      });

      return true;
    } catch (e) {
      print('Error uploading data archive: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAllArchives(String userId) async {
    try {
      // Mendapatkan dokumen pengguna berdasarkan userId
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Mengecek apakah dokumen ada dan memiliki data
      if (documentSnapshot.exists) {
        // Mengambil data arsip dari dokumen
        List<dynamic>? archives = documentSnapshot.get('archive');

        // Memastikan arsip bukan null dan mengembalikannya sebagai List<Map<String, dynamic>>
        if (archives != null) {
          return archives
              .map((archive) => Map<String, dynamic>.from(archive))
              .toList();
        }
      }

      // Jika dokumen tidak ada atau arsip tidak ditemukan, kembalikan list kosong
      return [];
    } catch (e) {
      print('Error getting archives: $e');
      return [];
    }
  }

  Future<String> uploadImageToFirebase(String imagePath) async {
    final storage = FirebaseStorage.instance;
    final ref = storage
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      final file = File(imagePath);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = ref.putFile(file, metadata);

      // uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      //   print('Task state: ${snapshot.state}');
      //   print(
      //       'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      // }, onError: (e) {
      //   print('Upload error: $e');
      // });

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      rethrow;
    }
  }
}
