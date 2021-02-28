import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messaging_app/model/mesaj.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/sohbet/konusma.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class SendImage extends StatefulWidget {
  final File imagee;
  final Kullanici currentUser;
  final Kullanici sohbetEdienUser;

  SendImage({this.imagee, this.currentUser, this.sohbetEdienUser});

  @override
  _SendImageState createState() => _SendImageState();
}

class _SendImageState extends State<SendImage> {
  Konusma konusma;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fotoğraf'),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.blue,
          child: Icon(Icons.navigation, size: 35, color: Colors.white),
          onPressed: () async {
            Mesaj _kaydedilecekMesaj = Mesaj(
              kimden: widget.currentUser.kullaniciID,
              kime: widget.sohbetEdienUser.kullaniciID,
              bendenMi: true,
              mesaj: '',
              photoURL: await saveImageMessage(),
            );
            await saveMesage(_kaydedilecekMesaj);
            Navigator.of(context).pop(_kaydedilecekMesaj);
          },
        ),
        body: Center(
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    child: Image.file(widget.imagee),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> saveImageMessage() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    String sonuc = await _userModel.saveImageMessage(widget.currentUser.kullaniciID, widget.sohbetEdienUser.kullaniciID, widget.imagee, 'image');
    return sonuc;
  }

  Future<bool> saveMesage(Mesaj kaydedilecekMesaj) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.saveMesage(kaydedilecekMesaj);
    return sonuc;
  }
}
