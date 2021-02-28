import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String kimden;
  final String kime;
  final bool bendenMi;
  final String mesaj;
  final Timestamp date;
  final String photoURL;

  Mesaj({this.photoURL, this.kimden, this.kime, this.bendenMi, this.mesaj, this.date});

  Map<String, dynamic> toMap() {
    return {'kimden': kimden, 'kime': kime, 'bendenMi': bendenMi, 'mesaj': mesaj, 'date': date ?? FieldValue.serverTimestamp(), 'photoURL': photoURL};
  }

  Mesaj.fromMap(Map<String, dynamic> map)
      : kimden = map['kimden'],
        kime = map['kime'],
        bendenMi = map['bendenMi'],
        mesaj = map['mesaj'],
        date = map['date'] as Timestamp,
        photoURL = map['photoURL'];

  String toString() {
    return 'mesaj{kimden:$kimden, kime:$kime ,bendenMi:$bendenMi, mesaj:$mesaj, date:$date}';
  }
}
