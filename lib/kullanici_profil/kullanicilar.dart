import 'package:flutter/material.dart';
import 'package:messaging_app/kullanici_profil/ornek_page1.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/sohbet/konusma.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
        actions: [
          FlatButton(
            child: Icon(Icons.adb),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Page1(),
                ),
              );
            },
          )
        ],
      ),
      body: FutureBuilder<List<Kullanici>>(
        future: _userModel.getAllUser(),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            List tumKullanicilar = sonuc.data;
            if (tumKullanicilar.length > 0) {
              return ListView.builder(
                itemCount: tumKullanicilar.length,
                itemBuilder: (context, index) {
                  if (sonuc.data[index].kullaniciID != _userModel.kullanici.kullaniciID) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => Konusma(
                              currentUser: _userModel.kullanici,
                              sohbetEdienUser: sonuc.data[index],
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(sonuc.data[index].userName),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(sonuc.data[index].profilURL),
                          backgroundColor: Colors.white,
                        ),
                        subtitle: Text(sonuc.data[index].email),
                      ),
                    );
                  } else
                    return Container();
                },
              );
            }
          } else
            return Center(
              child: Text("Kullanici Yok"),
            );
        },
      ),
    );
  }
}
