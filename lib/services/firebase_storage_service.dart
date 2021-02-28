import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:messaging_app/services/storageBase.dart';

class Firebase_Storage implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  var _storageReference;
  @override
  Future<String> uploadFile(String kullaniciID, String fileType, File file) async {
    _storageReference = _firebaseStorage.ref().child(kullaniciID).child(fileType);
    UploadTask uploadTask = _storageReference.putFile(file);
    var url = await (await uploadTask).ref.getDownloadURL();
    if (url == null) {
      return "foto yok foto yok foto yok ";
    } else
      print(url);
    return url;
  }

  @override
  Future<String> saveImageMessage(String kullaniciID, String sohbetEdilenID, File file, String fileType) async {
    _storageReference = _firebaseStorage.ref().child(kullaniciID + sayi() + sohbetEdilenID).child(fileType);
    UploadTask uploadTask = _storageReference.putFile(file);
    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  String sayi() {
    var sgn = new Random();
    return sgn.nextInt(1000).toString();
  }
}
