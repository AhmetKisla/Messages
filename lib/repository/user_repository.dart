import 'dart:io';
import 'package:timeago/timeago.dart' as timeago;
import 'package:messaging_app/locator.dart';
import 'package:messaging_app/model/konusma_model.dart';
import 'package:messaging_app/model/mesaj.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/services/auth_base.dart';
import 'package:messaging_app/services/fake_auth_services.dart';
import 'package:messaging_app/services/firebase_auth_services.dart';
import 'package:messaging_app/services/firebase_storage_service.dart';
import 'package:messaging_app/services/firestore.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthServices _firebaseAuthServices = locator<FirebaseAuthServices>();
  FakeAuthenticationService _fakeAuthenticationService = locator<FakeAuthenticationService>();
  FireStoreDbService _fireStoreDbService = locator<FireStoreDbService>();
  Firebase_Storage _firebase_storage = locator<Firebase_Storage>();
  AppMode appMode = AppMode.RELEASE;
  List<Kullanici> tumKullanicilar = [];

  @override
  Future<Kullanici> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      Kullanici kullanici = await _firebaseAuthServices.currentUser();
      Kullanici kullaniciNesnesi = await _fireStoreDbService.readUser(kullanici.kullaniciID);
      return kullaniciNesnesi;
    }
  }

  @override
  Future<Kullanici> singInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInAnonymously();
    } else {
      return await _firebaseAuthServices.singInAnonymously();
    }
  }

  @override
  Future<bool> singOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singOut();
    } else {
      return await _firebaseAuthServices.singOut();
    }
  }

  @override
  Future<Kullanici> createUserWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserWithEmailandPassword(email, sifre);
    } else {
      Kullanici kullanici = await _firebaseAuthServices.createUserWithEmailandPassword(email, sifre);
      bool sonuc = await _fireStoreDbService.saveUser(kullanici);
      if (sonuc) {
        Kullanici kullaniciNesnesi = await _fireStoreDbService.readUser(kullanici.kullaniciID);
        return kullaniciNesnesi;
      }
    }
  }

  @override
  Future<Kullanici> signInUserWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInUserWithEmailandPassword(email, sifre);
    } else {
      Kullanici kullanici = await _firebaseAuthServices.signInUserWithEmailandPassword(email, sifre);
      Kullanici kullaniciBilgiler = await _fireStoreDbService.readUser(kullanici.kullaniciID);
      return kullaniciBilgiler;
    }
  }

  Future<bool> updateUserName(String kullaniciID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDbService.updateUserName(kullaniciID, newUserName);
    }
  }

  Future<String> updateProfilFoto(String kullaniciID, String fileType, File image) async {
    if (appMode == AppMode.DEBUG) {
      return 'profil_foto_URL';
    } else {
      String profilUrl = await _firebase_storage.uploadFile(kullaniciID, fileType, image);
      await _fireStoreDbService.updateProfilFoto(kullaniciID, profilUrl);
      return profilUrl;
    }
  }

  Future<List<Kullanici>> getAllUser() async {
    tumKullanicilar = await _fireStoreDbService.getAllUser();
    return tumKullanicilar;
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDbService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<String> saveImageMessage(String kullaniciID, String sohbetEdilenID, File file, String fileType) async {
    if (appMode == AppMode.DEBUG) {
      return '';
    } else {
      String messagePhotoURL = await _firebase_storage.saveImageMessage(kullaniciID, sohbetEdilenID, file, fileType);
      return messagePhotoURL;
    }
  }

  Future<bool> saveMessages(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var sonuc = await _fireStoreDbService.saveMessage(kaydedilecekMesaj);
      return sonuc;
    }
  }

  Future<List<KonusmaModel>> getAllConversation(String kullaniciID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var konusmaListesi = await _fireStoreDbService.getAllConversation(kullaniciID);
      var _zaman = await _fireStoreDbService.saatiGoster(kullaniciID);

      //List<KonusmaModel> konusmalarim;
      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici = kullaniciBul(oankiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          print('LOKALDE VARDI GETİRİLDİ');
          oankiKonusma.userName = userListesindekiKullanici.userName; //Yarıtılan sohbetin eksik olan userName özelliğini tamamladık
          oankiKonusma.profilURL = userListesindekiKullanici.profilURL;
          zamanFarkiniGoster(_zaman, oankiKonusma);
        } else {
          print('LOKALDE YOKTU VERİTABANINDAN ÇEKİLDİ');
          var _veritabanindanOkunanUser = await _fireStoreDbService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.userName = _veritabanindanOkunanUser.userName;
          oankiKonusma.profilURL = _veritabanindanOkunanUser.profilURL;
          zamanFarkiniGoster(_zaman, oankiKonusma);
        }
      }

      return konusmaListesi;
    }
  }

  void zamanFarkiniGoster(DateTime _zaman, KonusmaModel oankiKonusma) {
    timeago.setLocaleMessages('tr', timeago.TrMessages());
    Duration duration = _zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.zamanFarki = timeago.format(_zaman.subtract(duration), locale: 'tr');
  }

  Kullanici kullaniciBul(String kullaniciID) {
    for (int i = 0; i < tumKullanicilar.length; i++) {
      if (tumKullanicilar[i].kullaniciID == kullaniciID) {
        return tumKullanicilar[i];
      } else
        return null;
    }
  }
}
