import 'package:flutter/material.dart';
import 'package:messaging_app/model/konusma_model.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/sohbet/konusma.dart';
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
            return RefreshIndicator(
              onRefresh: _konusmalarimListesiniYenile,
              child: ListView.builder(
                itemCount: konusmaListesi.data.length,
                itemBuilder: (context, index) {
                  KonusmaModel oankiKonusma = konusmaListesi.data[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => Konusma(
                            currentUser: _usermodel.kullanici,
                            sohbetEdienUser:
                                Kullanici.kullaniciIDandProfilURL(kullaniciID: oankiKonusma.kimle_konusuyor, profilURL: oankiKonusma.profilURL),
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(oankiKonusma.son_yollanan_mesaj),
                      subtitle: Row(
                        children: [
                          Text(oankiKonusma.userName),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                oankiKonusma.zamanFarki,
                                textAlign: TextAlign.end,
                                style: TextStyle(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      leading: CircleAvatar(
                        child: Image.network(oankiKonusma.profilURL),
                      ),
                    ),
                  );
                },
              ),
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

  Future<void> _konusmalarimListesiniYenile() async {
    setState(() {});
  }
}
