import 'package:firebase_storage/firebase_storage.dart';

class FBStorage {
  static final storage = FirebaseStorage.instance;

  static Future<String> getImageUrl(String path, String name) async {
    String url = await storage.ref('$path/$name').getDownloadURL();
    return url;
  }
}
