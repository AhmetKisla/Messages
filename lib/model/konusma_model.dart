import 'package:cloud_firestore/cloud_firestore.dart';

class KonusmaModel {
  final String kimle_konusuyor;
  final String konusma_sahibi;
  final Timestamp olusturulma_tarihi;
  final bool son_gorulme;
  final String son_yollanan_mesaj;
  final Timestamp gorulme_tarihi;
  String userName;
  String profilURL;
  String zamanFarki;

  KonusmaModel({this.kimle_konusuyor, this.konusma_sahibi, this.olusturulma_tarihi, this.son_gorulme, this.son_yollanan_mesaj, this.gorulme_tarihi});
  Map<String, dynamic> toMap() {
    return {
      'kimle_konusuyor': kimle_konusuyor,
      'konusma_sahibi': konusma_sahibi,
      'olusturulma_tarihi': olusturulma_tarihi ?? FieldValue.serverTimestamp(),
      'son_gorulme': son_gorulme,
      'son_yollanan_mesaj': son_yollanan_mesaj,
      'gorulme_tarihi': gorulme_tarihi ?? FieldValue.serverTimestamp(),
    };
  }

  KonusmaModel.fromMap(Map<String, dynamic> map)
      : kimle_konusuyor = map['kimle_konusuyor'],
        konusma_sahibi = map['konusma_sahibi'],
        olusturulma_tarihi = map['olusturulma_tarihi'],
        son_gorulme = map['son_gorulme'],
        son_yollanan_mesaj = map['son_yollanan_mesaj'],
        gorulme_tarihi = map['gorulme_tarihi'];

  String toString() {
    return 'Konusma{kimle_konusuyor:$kimle_konusuyor, konusma_sahibi:$konusma_sahibi ,olusturulma_tarihi:$olusturulma_tarihi, son_gorulme:$son_gorulme, son_yollanan_mesaj:$son_yollanan_mesaj,gorulme_tarihi:$gorulme_tarihi}';
  }
}
