import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/services/auth_base.dart';

class FirebaseAuthServices implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<Kullanici> currentUser() async {
    // TODO: implement currentUser

    try {
      User user = await _firebaseAuth.currentUser;
      return _kullaniciFromUser(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
    }
  }

  Kullanici _kullaniciFromUser(User user) {
    if (user == null) {
      return null;
    }
    return Kullanici(kullaniciID: user.uid, email: user.email);
  }

  @override
  Future<Kullanici> singInAnonymously() async {
    // TODO: implement singInAnonymously
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return _kullaniciFromUser(sonuc.user);
    } catch (e) {
      print("ANONİM GİRİŞ HATA:" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> singOut() async {
    // TODO: implement singOut
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("SİNG OUT HATA:" + e.toString());
    }

    return false;
  }

  @override
  Future<Kullanici> createUserWithEmailandPassword(String email, String sifre) async {
    // TODO: implement createUserWithEmailandPassword
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: sifre);
    debugPrint("Kullanıcı oluşturuldu.");
    return _kullaniciFromUser(sonuc.user);
  }

  @override
  Future<Kullanici> signInUserWithEmailandPassword(String email, String sifre) async {
    // TODO: implement signInUserWithEmailandPassword
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: sifre);
    return _kullaniciFromUser(sonuc.user);
  }
}
