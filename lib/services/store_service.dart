import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoreService{
  static final _storage = FirebaseStorage.instance.ref();
  static const folder = "post_image";


  static Future<String?> uploadImage(File? _image)async{
    String? imgUrl;
    print("aaaa${_image}");
    String imgName = "image_" + DateTime.now().toString();
    Reference firebaseStorageRef =  _storage.child(folder).child(imgName);
    if(_image != null) {
      await firebaseStorageRef.putFile(_image).then((getUrlFromBase) async {
        if (getUrlFromBase.metadata == null) {
          imgUrl = null;
        } else {
          final String downloadUrl = await getUrlFromBase.ref.getDownloadURL();
          imgUrl = downloadUrl;
          return null;
        }
      });
    }
    return imgUrl;
  }
}