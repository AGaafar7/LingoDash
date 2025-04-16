import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with Email and Password
  Future<fb.User?> registerWithEmail(
    String email,
    String password,
    String role,
  ) async {
    try {
      fb.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': role,
        'subscriptionActive': true,
      });
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      print('Error in registerWithEmail: $e');
      notifyListeners();
      return null;
    }
  }

  // Register with Google
  Future<fb.User?> registerWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      fb.UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'role': 'user',
        'subscriptionActive': true,
      });
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      print('Error in registerWithGoogle: $e');
      notifyListeners();
      return null;
    }
  }

  // Register with Phone
  Future<void> registerWithPhone(
    String phoneNumber,
    Function(String) codeSentCallback,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fb.PhoneAuthCredential credential) async {
          fb.UserCredential userCredential = await _auth.signInWithCredential(
            credential,
          );

          // Create user document in Firestore
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set({
                'phone': phoneNumber,
                'role': 'user',
                'subscriptionActive': true,
              });
        },
        verificationFailed: (fb.FirebaseAuthException e) {
          notifyListeners();
          print('Error in registerWithPhone: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          notifyListeners();
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          notifyListeners();
        },
      );
    } catch (e) {
      notifyListeners();
      print('Error in registerWithPhone: $e');
    }
  }

  // Login with Email and Password
  Future<fb.User?> loginWithEmail(String email, String password) async {
    try {
      fb.UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      print('Error in loginWithEmail: $e');
      notifyListeners();
      return null;
    }
  }

  // Login/Register with Google
  Future<fb.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      fb.UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Check if user exists in Firestore, if not create a new document
      final userDoc =
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'role': 'user',
          'subscriptionActive': true,
        });
      }
      notifyListeners();
      return userCredential.user;
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      notifyListeners();
      return null;
    }
  }

  // Login/Register with Phone
  Future<fb.User?> signInWithPhone(
    String phoneNumber,
    Function(String) codeSentCallback,
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (fb.PhoneAuthCredential credential) async {
          fb.UserCredential userCredential = await _auth.signInWithCredential(
            credential,
          );

          // Check if user exists in Firestore, if not create a new document
          final userDoc =
              await _firestore
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .get();
          if (!userDoc.exists) {
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
                  'phone': phoneNumber,
                  'role': 'user',
                  'subscriptionActive': true,
                });
          }
        },
        verificationFailed: (fb.FirebaseAuthException e) {
          notifyListeners();
          print('Error in signInWithPhone: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          notifyListeners();
          codeSentCallback(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          notifyListeners();
        },
      );
      return null;
    } catch (e) {
      notifyListeners();
      print('Error in signInWithPhone: $e');
      return null;
    }
  }

  // Logout
  Future<void> logout() async {
    notifyListeners();
    await _auth.signOut();
  }
}
