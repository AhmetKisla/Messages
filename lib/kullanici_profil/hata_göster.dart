class Hatalar {
  static String hataGoster(String hata) {
    switch (hata) {
      case 'email-already-in-use':
        return 'Email Zaten Kullanılıyor, Lütfen Başka Bir Email Kullanın';
      case 'user-not-found':
        return 'Böyle Bir Kullanıcı Bulunmamakta, Lütfen Email veya Şifrenizi Kotrol Edin.';

      default:
        return 'Bir Hata olustu';
    }
  }
}
