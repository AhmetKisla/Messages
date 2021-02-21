import 'package:messaging_app/model/mesaj.dart';
import 'package:messaging_app/model/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(Kullanici kullanici);
  Future<Kullanici> readUser(String kullaniciID);
  Future<bool> updateUserName(String kullaniciID, String newUserName);
  Future<bool> updateProfilFoto(String kullaniciID, String profilUrl);
  Future<List<Kullanici>> getAllUser();
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
}
