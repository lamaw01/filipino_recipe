import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';

class FBStorage {
  static final storage = FirebaseStorage.instance;

  static Future<String> downloadUrl(String name) async {
    String url = await storage.ref('images/$name').getDownloadURL();
    log(url);
    return url;
  }
}
