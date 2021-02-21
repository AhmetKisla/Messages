//setstate kullanılmasının önüne geçmeyi hedefliyor
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:messaging_app/locator.dart';
import 'package:messaging_app/model/mesaj.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/repository/user_repository.dart';
import 'package:messaging_app/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  Kullanici _kullanici;
  String emailHataMesaji;
  String sifreHataMesaji;

  Kullanici get kullanici => _kullanici;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners(); //Durum değişikliğini dinleriz.
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<Kullanici> currentUser() async {
    // TODO: implement currentUser
    try {
      state = ViewState.Busy;
      _kullanici = await _userRepository.currentUser();
      return _kullanici;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata:" + e.toString());
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Kullanici> singInAnonymously() async {
    // TODO: implement singInAnonymously
    try {
      state = ViewState.Busy;
      _kullanici = await _userRepository.singInAnonymously();
      return _kullanici; //Oturum açmış kullanıcıyı geri döndürme işlemi.
    } catch (e) {
      debugPrint("Viewmodeldeki singInAnonymously  hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> singOut() async {
    // TODO: implement singOut
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.singOut();
      _kullanici = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki singOut  hata:" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Kullanici> createUserWithEmailandPassword(String email, String sifre) async {
    // TODO: implement createUserWithEmailandPassword
    try {
      if (_emailSifreKontrol(email, sifre) == true) {
        state = ViewState.Busy;
        _kullanici = await _userRepository.createUserWithEmailandPassword(email, sifre);
        return _kullanici; //Oturum açmış kullanıcıyı geri döndürme işlemi.
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Kullanici> signInUserWithEmailandPassword(String email, String sifre) async {
    // TODO: implement signInUserWithEmailandPassword
    try {
      if (_emailSifreKontrol(email, sifre) == true) {
        state = ViewState.Busy;
        _kullanici = await _userRepository.signInUserWithEmailandPassword(email, sifre);
        return _kullanici; //Oturum açmış kullanıcıyı geri döndürme işlemi.
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<List<Kullanici>> getAllUser() async {
    List tumKullanicilar = await _userRepository.getAllUser();
    return tumKullanicilar;
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (!email.contains("@")) {
      emailHataMesaji = "Hatalı email";
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }

    if (sifre.length < 6) {
      sifreHataMesaji = "Sifre en az 6 karekter içermelidir.";
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }
    return sonuc;
  }

  Future<bool> updateUserName(String kullaniciID, String newUserName) async {
    bool sonuc = await _userRepository.updateUserName(kullaniciID, newUserName);
    return sonuc;
  }

  Future<String> updateProfilFoto(String kullaniciID, String fileType, File image) async {
    String profilURL = await _userRepository.updateProfilFoto(kullaniciID, fileType, image);
    return profilURL;
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID) {
    return _userRepository.getMessages(currentUserID, sohbetEdilenUserID);
  }

  Future<bool> saveMesage(Mesaj kaydedilecekMesaj) {
    var sonuc = _userRepository.saveMessages(kaydedilecekMesaj);
    return sonuc;
  }
}
