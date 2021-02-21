import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfiPage extends StatefulWidget {
  @override
  _ProfiPageState createState() => _ProfiPageState();
}

class _ProfiPageState extends State<ProfiPage> {
  TextEditingController _userNamecontroller;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userNamecontroller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userNamecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    print('profil sayfasındaki user değeri:' + _userModel.kullanici.toString());
    _userNamecontroller.text = _userModel.kullanici.userName;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          FlatButton(
              child: Text(
                "Çıkış",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                _cikisYap(context);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 160,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.image),
                                title: Text("Galeriden Seç"),
                                onTap: () {
                                  _galeridenResimSec();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text("Kameradan Seç"),
                                onTap: () {
                                  _kameradanFotoCek();
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: _image == null ? NetworkImage(_userModel.kullanici.profilURL) : FileImage(_image),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onTap: () {},
                  readOnly: true,
                  initialValue: _userModel.kullanici.email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _userNamecontroller,
                  onTap: () {},
                  decoration: InputDecoration(
                    labelText: 'Kullanici Adı',
                    hintText: 'Kullanıcı Adı',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      _userNameGuncelle(context);
                      _profilFotoGuncelle(context);
                    },
                    color: Colors.blue,
                    child: Text('Değişiklikleri Kaydet'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false); // Neden false kullandık öğren.
    bool sonuc = await _userModel.singOut();
    return sonuc;
  }

  void _userNameGuncelle(BuildContext context) async {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.kullanici.userName != _userNamecontroller.text) {
      bool update = await _userModel.updateUserName(_userModel.kullanici.kullaniciID, _userNamecontroller.text);
      if (update) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Başarılı'),
              content: Text('Kullanici Adi Değiştirildi'),
              actions: [
                FlatButton(
                  child: Text('Tamam'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          },
        );
      } else {
        _userNamecontroller.text = _userModel.kullanici.userName;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Hata Oluştu'),
              content: Text('Kullanici Adi Zaten Kullanılıyor,Lütfen Başka Bir Seçim Yapın'),
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

  Future<void> _galeridenResimSec() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.of(context).pop();
      } else {
        print('No image selected.');
      }
    });
  }

  void _kameradanFotoCek() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Navigator.of(context).pop();
      } else {
        print('No image selected.');
      }
    });
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_image != null) {
      var profilURL = await _userModel.updateProfilFoto(_userModel.kullanici.kullaniciID, 'profil_foto', _image);
      print('Gelen URL:' + profilURL);
    }
  }
}
