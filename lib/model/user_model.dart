import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Kullanici {
  final String kullaniciID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updatedAt;
  int seviye;

  Kullanici({@required this.kullaniciID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'kullaniciID': kullaniciID,
      'email': email,
      'userName': userName ?? email.substring(0, email.indexOf('@')) + randomSayi(),
      'profilURL': profilURL ?? 'https://i.tmgrup.com.tr/gq/original/17-06/22/user_male_circle_filled1600.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  Kullanici.fromMap(Map<String, dynamic> map)
      : kullaniciID = map['kullaniciID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];

  String toString() {
    return 'Kullanici{kullaniciID: $kullaniciID,email: $email,userName:$userName,profilURL:$profilURL,createdAt:$createdAt,updatedAt:$updatedAt,seviye:$seviye}';
  }

  String randomSayi() {
    int random;
    random = Random().nextInt(1000);
    return random.toString();
  }
}
