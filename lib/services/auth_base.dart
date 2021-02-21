import 'package:firebase_auth/firebase_auth.dart';
import 'package:messaging_app/model/user_model.dart';

abstract class AuthBase {
  Future<Kullanici> currentUser();
  Future<Kullanici> singInAnonymously();
  Future<bool> singOut();
  Future<Kullanici> createUserWithEmailandPassword(String email, String sifre);
  Future<Kullanici> signInUserWithEmailandPassword(String email, String sifre);
}
