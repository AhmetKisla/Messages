import 'dart:io';

abstract class StorageBase {
  Future<String> uploadFile(String kullaniciID, String fileType, File file);
  Future<String> saveImageMessage(String kullaniciID, String sohbetEdilenID, File file, String fileType);
}
