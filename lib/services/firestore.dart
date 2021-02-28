import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging_app/model/konusma_model.dart';
import 'package:messaging_app/model/mesaj.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/services/db_base.dart';

class FireStoreDbService implements DbBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Kullanici kullanici) async {
    // TODO: implement saveUser
    await _firebaseFirestore.collection("users").doc(kullanici.kullaniciID).set(kullanici.toMap());
    DocumentSnapshot _okunanKullanici = await _firebaseFirestore.doc("users/${kullanici.kullaniciID}").get();
    Map _okunanUserBilgileriMap = _okunanKullanici.data();
    Kullanici _okunanKullaniciBilgileriNesne = Kullanici.fromMap(_okunanUserBilgileriMap);
    //print(_okunanKullaniciBilgileriNesne.toString());
    return true;
  }

  @override
  Future<Kullanici> readUser(String userID) async {
    DocumentSnapshot _okunanKullanici = await _firebaseFirestore.collection("users").doc(userID).get();
    Map<String, dynamic> _okunanKullaniciBilgileriMap = _okunanKullanici.data();
    Kullanici _okunanKullaniciBilgileriNesnesi = Kullanici.fromMap(_okunanKullaniciBilgileriMap);
    print(_okunanKullaniciBilgileriNesnesi.toString());
    return _okunanKullaniciBilgileriNesnesi;
  }

  @override
  Future<bool> updateUserName(String kullaniciID, String newUserName) async {
    var users = await _firebaseFirestore.collection('users').where('userName', isEqualTo: newUserName).get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseFirestore.collection('users').doc(kullaniciID).update({'userName': newUserName});
      return true;
    }
  }

  Future<bool> updateProfilFoto(String kullaniciID, String profilUrl) async {
    await _firebaseFirestore.collection('users').doc(kullaniciID).update({'profilURL': profilUrl});
    return true;
  }

  @override
  Future<List<Kullanici>> getAllUser() async {
    // TODO: implement getAllUser
    QuerySnapshot querySnapshot = await _firebaseFirestore.collection('users').get();
    List<Kullanici> tumKullanicilar = [];
    for (DocumentSnapshot tekUser in querySnapshot.docs) {
      print('selam okunan user:' + tekUser.data().toString());
      Kullanici kullanici = Kullanici.fromMap(tekUser.data());
      print(kullanici.userName);
      tumKullanicilar.add(kullanici);
    }
    return tumKullanicilar;
  }

  //Bu kısımda mesajları elde ettik **** Tekrar incele
  @override
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserId) {
    var snapShot = _firebaseFirestore
        .collection('konusmalar')
        .doc(currentUserID + '--' + konusulanUserId)
        .collection('mesajlar')
        .orderBy('date', descending: true)
        .snapshots();
    return snapShot.map((mesajListesi) => mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseFirestore.collection('konusmalar').doc().id;
    var _myDocumentID = kaydedilecekMesaj.kimden + '--' + kaydedilecekMesaj.kime;
    var _receiverDocumentID = kaydedilecekMesaj.kime + '--' + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();

    await _firebaseFirestore.collection('konusmalar').doc(_myDocumentID).collection('mesajlar').doc(_mesajID).set(_kaydedilecekMesajMapYapisi);

    await _firebaseFirestore.collection('konusmalar').doc(_myDocumentID).set({
      'konusma_sahibi': kaydedilecekMesaj.kimden,
      'kimle_konusuyor': kaydedilecekMesaj.kime,
      'son_yollanan_mesaj': kaydedilecekMesaj.mesaj,
      'son_gorulme': false,
      'olusturulma_tarihi': FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update('bendenMi', (value) => false);
    await _firebaseFirestore.collection('konusmalar').doc(_receiverDocumentID).collection('mesajlar').doc(_mesajID).set(_kaydedilecekMesajMapYapisi);

    await _firebaseFirestore.collection('konusmalar').doc(_receiverDocumentID).set({
      'konusma_sahibi': kaydedilecekMesaj.kime,
      'kimle_konusuyor': kaydedilecekMesaj.kimden,
      'son_yollanan_mesaj': kaydedilecekMesaj.mesaj,
      'son_gorulme': false,
      'olusturulma_tarihi': FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<KonusmaModel>> getAllConversation(String kullaniciID) async {
    List<KonusmaModel> tumKonusmalar = [];
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: kullaniciID)
        .orderBy('olusturulma_tarihi', descending: true)
        .get();

    for (DocumentSnapshot tekKonusma in querySnapshot.docs) {
      tumKonusmalar.add(KonusmaModel.fromMap(tekKonusma.data()));
    }
    return tumKonusmalar;
  }

  @override
  Future<DateTime> saatiGoster(kullaniciID) async {
    await _firebaseFirestore.collection('server').doc(kullaniciID).set({
      'saat': FieldValue.serverTimestamp(),
    });
    var okunanMap = await _firebaseFirestore.collection('server').doc(kullaniciID).get();
    Timestamp okunanTarih = okunanMap.data()['saat'];
    return okunanTarih.toDate();
  }
}
