import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nutralyse_jd/common/config/storage.dart';
import 'package:nutralyse_jd/service/firebase/auth_exception_handler.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  AuthResultStatus status = AuthResultStatus.undefined;
  SecureStorage _secureStorage = SecureStorage();

  // Login with email and password
  Future<AuthResultStatus> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (authResult.user != null) {
        await _secureStorage.saveUserId(authResult.user!.uid);
        status = AuthResultStatus.successful;
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        status = AuthExceptionHandler.handleException(e);
      } else {
        status = AuthResultStatus.undefined;
      }
    }
    return status;
  }

  // Signup user with email and password (dengan tanggal lahir & jenis kelamin)
  Future<AuthResultStatus> signupWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required String tanggalLahir,
    required String jenisKelamin,
  }) async {
    try {
      final UserCredential authResult =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (authResult.user != null) {
        _saveUserDetails(
          fullName: fullName,
          email: email,
          userId: authResult.user!.uid,
          tanggalLahir: tanggalLahir,
          jenisKelamin: jenisKelamin,
        );
        status = AuthResultStatus.successful;
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        status = AuthExceptionHandler.handleException(e);
      } else {
        print(e);
        status = AuthResultStatus.undefined;
      }
    }
    return status;
  }

  // Login with Google
  Future<AuthResultStatus> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (authResult.user != null) {
          _saveUserDetails(
            fullName: authResult.user!.displayName ?? '',
            email: authResult.user!.email!,
            userId: authResult.user!.uid,
            tanggalLahir: "-", // default kosong
            jenisKelamin: "-", // default kosong
          );
          await _secureStorage.saveUserId(authResult.user!.uid);
          status = AuthResultStatus.successful;
        } else {
          status = AuthResultStatus.undefined;
        }
      } else {
        status = AuthResultStatus.undefined;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        status = AuthExceptionHandler.handleException(e);
      } else {
        status = AuthResultStatus.undefined;
      }
    }
    return status;
  }

  // Save user details to Firestore
  void _saveUserDetails({
    required String fullName,
    required String email,
    required String userId,
    required String tanggalLahir,
    required String jenisKelamin,
  }) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fullName': fullName,
      'email': email,
      'userId': userId,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'classificationCompleted': false,
    });
  }

  // Ambil profile user dari Firestore
  Future<Map<String, dynamic>?> getProfileUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Reset password
  Future<AuthResultStatus> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      status = AuthResultStatus.successful;
    } catch (e) {
      if (e is FirebaseAuthException) {
        status = AuthExceptionHandler.handleException(e);
      } else {
        status = AuthResultStatus.undefined;
      }
    }
    return status;
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      await _secureStorage.deleteUserId();

      context.go('/login'); // arahkan kembali ke login
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
