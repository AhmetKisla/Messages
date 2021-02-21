import 'package:cloud_firestore/cloud_firestore.dart';

class Mesaj {
  final String kimden;
  final String kime;
  final bool bendenMi;
  final String mesaj;
  final DateTime date;

  Mesaj({this.kimden, this.kime, this.bendenMi, this.mesaj, this.date});

  Map<String, dynamic> toMap() {
    return {'kimden': kimden, 'kime': kime, 'bendenMi': bendenMi, 'mesaj': mesaj, 'date': date ?? FieldValue.serverTimestamp()};
  }

  Mesaj.fromMap(Map<String, dynamic> map)
      : kimden = map['kimden'],
        kime = map['kime'],
        bendenMi = map['bendenMi'],
        mesaj = map['mesaj'],
        date = (map['date'] as Timestamp).toDate();

  String toString() {
    return 'mesaj{kimden:$kimden, kime:$kime ,bendenMi:$bendenMi, mesaj:$mesaj, date:$date}';
  }
}