import 'dart:io';

abstract class StorageBase {
  Future<String> uploadFile(String kullaniciID, String fileType, File file);
}
