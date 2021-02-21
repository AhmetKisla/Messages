import 'package:flutter/material.dart';
import 'package:messaging_app/common_widget/social_login_button.dart';
import 'package:messaging_app/email_sifre_giris.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class SingInPage extends StatelessWidget {
  Future<void> _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Kullanici kullanici = await _userModel.singInAnonymously();
    print("Oturum açan user id:" + kullanici.kullaniciID.toString());
  }

  Future<void> _emailveSifreGiris(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => (EmailveSifreLoginPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oturum aç",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
            /*SocialLoginButton(
              butonIcon: Icon(Icons.),
              textColor: Colors.white,
              butonText: "Google ile oturum aç",
              butonColor: Colors.red,
              onPressed: () {},
              radius: 16,
            ),*/
            SocialLoginButton(
              butonIcon: Icon(Icons.email),
              textColor: Colors.white,
              butonText: "Email ve Şifre ile Giriş Yap",
              butonColor: Color(0xFF334D92),
              onPressed: () => _emailveSifreGiris(context),
              radius: 16,
            ),
            SocialLoginButton(
              butonIcon: Icon(Icons.person),
              textColor: Colors.white,
              butonText: "Misafir Girişi",
              butonColor: Colors.green,
              onPressed: () => _misafirGirisi(context),
              radius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
