import 'package:hive/hive.dart';

class HiveDB{
  static String DB_NAME = "firebase";
  static var box = Hive.box(DB_NAME);

  //////put
  static void storeU(String uid) async{
    box.put("uid", uid);
  }

  //////get
  static dynamic loadU(){
    return box.get("uid");
  }

  /////delate
  static Future<void> removeUid(){
    return box.delete("uid");
  }

}