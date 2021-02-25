import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/model/konusma_model.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class Konusmalarim_Page extends StatefulWidget {
  @override
  _Konusmalarim_PageState createState() => _Konusmalarim_PageState();
}

class _Konusmalarim_PageState extends State<Konusmalarim_Page> {
  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    //_konusmalarimiGetir();
    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<KonusmaModel>>(
        future: _usermodel.getAllConversation(_usermodel.kullanici.kullaniciID),
        builder: (context, konusmaListesi) {
          if (konusmaListesi.hasData) {
            return ListView.builder(
              itemCount: konusmaListesi.data.length,
              itemBuilder: (context, index) {
                KonusmaModel oankiKonusma = konusmaListesi.data[index];
                return ListTile(
                  title: Text(oankiKonusma.son_yollanan_mesaj),
                  subtitle: Text(oankiKonusma.userName),
                  leading: CircleAvatar(
                    child: Image.network(oankiKonusma.profilURL),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  /* void _konusmalarimiGetir() async {
    QuerySnapshot konusmalarim = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _usermodel.kullanici.kullaniciID)
        .orderBy('olusturulma_tarihi', descending: true)
        .get();
    for (var konusma in konusmalarim.docs) {
      debugPrint("konusma:" + konusma.data().toString());
    }
  }*/
}
