import 'package:flutter/material.dart';
import 'package:messaging_app/kullanici_profil/kullanicilar.dart';
import 'package:messaging_app/kullanici_profil/my_custom_bottom.dart';
import 'package:messaging_app/kullanici_profil/profil.dart';
import 'package:messaging_app/kullanici_profil/tab_items.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/sohbet/konusmalarim.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final Kullanici kullanici;

  HomePage({Key key, @required this.kullanici}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar;
  Map<TabItem, Widget> tumSayfalar() {
    return {TabItem.Kullanicilar: KullanicilarPage(), TabItem.Profil: ProfiPage(), TabItem.Konusmalarim: Konusmalarim_Page()};
  }

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
  };

  /*Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false); // Neden false kullandık öğren.
    bool sonuc = await _userModel.singOut();
    return sonuc;
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        navigatorKeys: navigatorKeys,
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            //Eğer BottomBarda kullanıcılar seçili ve stac üzerine yeni sayfalar koyulmuş ise tekrar kullanıcılar iconunun seçilmesiyle kullanıcılara dönülür.
            navigatorKeys[secilenTab].currentState.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
