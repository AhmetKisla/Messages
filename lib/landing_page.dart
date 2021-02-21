import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/home_page.dart';
import 'package:messaging_app/locator.dart';
import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/services/auth_base.dart';
import 'package:messaging_app/services/firebase_auth_services.dart';
import 'package:messaging_app/sign_in_page.dart';
import 'package:messaging_app/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.kullanici == null) {
        return SingInPage();
      } else {
        return HomePage(kullanici: _userModel.kullanici);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
