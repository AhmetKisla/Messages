import 'package:messaging_app/model/user_model.dart';
import 'package:messaging_app/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String kullaniciId = "1234567852";
  @override
  Future<Kullanici> currentUser() async {
    // TODO: implement currentUser
    return await Future.value(Kullanici(kullaniciID: kullaniciId, email: "ahmet@gmail.com"));
  }

  @override
  Future<Kullanici> singInAnonymously() async {
    // TODO: implement singInAnonymously
    return await Future.delayed(Duration(seconds: 2), () => Kullanici(kullaniciID: kullaniciId, email: "ahmet@gmail.com"));
  }

  @override
  Future<bool> singOut() {
    // TODO: implement singOut
    return Future.value(true);
  }

  @override
  Future<Kullanici> createUserWithEmailandPassword(String email, String sifre) {
    // TODO: implement createUserWithEmailandPassword
    throw UnimplementedError();
  }

  @override
  Future<Kullanici> signInUserWithEmailandPassword(String email, String sifre) {
    // TODO: implement signInUserWithEmailandPassword
    throw UnimplementedError();
  }
}
