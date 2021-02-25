import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messaging_app/model/mesaj.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class Konusma extends StatefulWidget {
  final Kullanici currentUser;
  final Kullanici sohbetEdienUser;

  Konusma({this.currentUser, this.sohbetEdienUser});
  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    Kullanici _currentUser = widget.currentUser;
    Kullanici _sohbetEdilenUser = widget.sohbetEdienUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder<List<Mesaj>>(
              stream: _userModel.getMessages(
                _currentUser.kullaniciID,
                _sohbetEdilenUser.kullaniciID,
              ),
              builder: (context, streamMesajlarListesi) {
                if (!streamMesajlarListesi.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Mesaj> tumMesajlar = streamMesajlarListesi.data;
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: tumMesajlar.length,
                  itemBuilder: (context, index) {
                    return _konusmaBalonuOlustur(tumMesajlar[index]);
                  },
                );
              },
            )),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      maxLength: 100,
                      controller: _mesajController,
                      cursorColor: Colors.blueGrey,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Mesajınızı Yazınız',
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.navigation, size: 35, color: Colors.white),
                      onPressed: () async {
                        if (_mesajController.text.trim().length > 0) {
                          Mesaj _kaydedilecekMesaj = Mesaj(
                            kimden: _currentUser.kullaniciID,
                            kime: _sohbetEdilenUser.kullaniciID,
                            bendenMi: true,
                            mesaj: _mesajController.text,
                          );
                          var sonuc = await _userModel.saveMesage(_kaydedilecekMesaj);
                          if (sonuc) {
                            print('selam');

                            _mesajController.clear();
                            _scrollController.animateTo(
                              0.0,
                              curve: Curves.slowMiddle,
                              duration: const Duration(milliseconds: 100),
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Colors.purple;
    String saatDk = "";
    try {
      saatDk = _saatDkgoster(oankiMesaj.date);
    } catch (e) {
      print("Saat Getirilirken Hata Olustu:" + e.toString());
    }
    var _benimMesajimMi = oankiMesaj.bendenMi;
    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: _gidenMesajRenk),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(saatDk),
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.sohbetEdienUser.profilURL),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: _gelenMesajRenk),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj),
                  ),
                ),
                Text(saatDk),
              ],
            )
          ],
        ),
      );
    }
  }

  String _saatDkgoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    String _formatliTarih = _formatter.format(date.toDate());
    return _formatliTarih;
  }
}
