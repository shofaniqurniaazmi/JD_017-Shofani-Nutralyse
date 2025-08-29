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

  // Signup user with email and password
  Future<AuthResultStatus> signupWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
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
  }) {
    FirebaseFirestore.instance.collection('users').doc(userId).set({
      'fullName': fullName,
      'email': email,
      'userId': userId,
      'classificationCompleted': false,
    });
  }

  // Submit user classification
  Future<void> submitUserClassification({
    required String userId,
    required double weight,
    required double height,
    required String classification,
    required int age,
    required String gender,
    required BuildContext context,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'weight': weight,
        'height': height,
        'classification': classification,
        'age': age,
        'gender': gender,
        'classificationCompleted': true,
      });

      context.go('/home');
    } catch (e) {
      print('Submit classification error: $e');
    }
  }

  // Check if user has completed classification
  Future<bool> isClassificationCompleted(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['classificationCompleted'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking classificationCompleted: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfileUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Return the user data as a Map<String, dynamic>
        return userDoc.data() as Map<String, dynamic>;
      } else {
        // Document does not exist
        return null;
      }
    } catch (e) {
      // Handle errors here
      print('Error fetching user profile: $e');
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Sign out from Google Sign-In if the user is signed in with Google
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Clear user data from secure storage
      await _secureStorage.deleteUserId();

      // Redirect to the login page or any other page
      context.go('/login'); // Update the route as needed
    } catch (e) {
      print('Logout error: $e');
      // Optionally, show an error message to the user
    }
  }
}
