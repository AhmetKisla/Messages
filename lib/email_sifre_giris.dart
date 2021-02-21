import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging_app/common_widget/social_login_button.dart';
import 'package:messaging_app/home_page.dart';
import 'package:messaging_app/kullanici_profil/hata_g%C3%B6ster.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _butonText, _linkText;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    final _userModel = Provider.of<UserModel>(context, listen: false);
    debugPrint("email:" + _email + "Şifre:" + _sifre);
    // ignore: unrelated_type_equality_checks
    if (_formType == FormType.LogIn) {
      try {
        Kullanici _girisYapanKullanici = await _userModel.signInUserWithEmailandPassword(_email, _sifre);
        if (_girisYapanKullanici != null) print("Giris yapan kullanici:" + _girisYapanKullanici.toString());
      } catch (e) {
        debugPrint("widget oturum açma hata yakalandı:" + e.code);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Kullanıcı Girişi Hata'),
              content: Text(Hatalar.hataGoster(e.code)),
              actions: [
                FlatButton(
                  child: Text('Tamam'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          },
        );
      }
    } else {
      try {
        Kullanici _olusturulanKullanici = await _userModel.createUserWithEmailandPassword(_email, _sifre);
        if (_olusturulanKullanici != null) {
          print("Oturum açan kullanici" + _olusturulanKullanici.kullaniciID.toString());
        }
      } catch (e) {
        debugPrint("widget kullanıci olusturma hata yakaladı " + e.code);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Hata'),
              content: Text(Hatalar.hataGoster(e.code)),
              actions: [
                FlatButton(
                  child: Text('Tamam'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          },
        );
      }
    }
  }

  //Form tipinin değiştirilmesini sağlayan methodumuz.
  void degistir() {
    setState(() {
      if (_formType == FormType.LogIn) {
        _formType = FormType.Register;
      } else
        _formType = FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.LogIn ? "Giriş Yap" : "Kayıt ol";
    _linkText = _formType == FormType.LogIn ? "Hesabınız Yok Mu ? Kayıt ol" : "Hesabınız Var Mı ? Giriş Yap";

    final _userModel = Provider.of<UserModel>(context); //Tıklama kullanılmadığı için listen:false kullanılmaz

    /* final _userModel = Provider.of<UserModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.kullanici != null) {
        return HomePage(kullanici: _userModel.kullanici);
      } else {
        
      }
    } else {
      return
      );*/

    if (_userModel.kullanici != null) {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş/Kayıt"),
      ),
      body: _userModel.state == ViewState.Idle
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      TextFormField(
                        // key: _formKey,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          labelText: 'Email',
                          errorText: _userModel.emailHataMesaji != null ? _userModel.emailHataMesaji : null,
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String girilenEmail) {
                          _email = girilenEmail;
                        },
                      ),
                      SizedBox(
                        height: 10,
                        width: 10,
                      ),
                      TextFormField(
                        // key: _formKey,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Şifre',
                          labelText: 'Şifre',
                          errorText: _userModel.sifreHataMesaji != null ? _userModel.sifreHataMesaji : null,
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onSaved: (girilenSifre) {
                          _sifre = girilenSifre;
                        },
                      ),
                      RaisedButton(
                        color: Colors.blue,
                        child: Text(_butonText),
                        onPressed: () => _formSubmit(),
                      ),
                      FlatButton(
                        onPressed: () => degistir(),
                        child: Text(_linkText),
                      )
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
