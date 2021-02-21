import 'package:get_it/get_it.dart';
import 'package:messaging_app/repository/user_repository.dart';
import 'package:messaging_app/services/fake_auth_services.dart';
import 'package:messaging_app/services/firebase_auth_services.dart';
import 'package:messaging_app/services/firebase_storage_service.dart';
import 'package:messaging_app/services/firestore.dart';

GetIt locator = GetIt.instance;
//locator sayesinde kuruculardan kurtulmayı planlıyoruz
void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthServices());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FireStoreDbService());
  locator.registerLazySingleton(() => Firebase_Storage());
}
