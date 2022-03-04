

import 'package:firebase_database/firebase_database.dart';

import '../post_model/post_model.dart';

class RTDGService{
  static final _database = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Post post) async{
    _database.child("posts/").push().set(post.toJson());
    return _database.onChildAdded;
  }

  static Future<List<Post>> getPost(String id)async{
    List<Post> items = [];
    Query _query = _database.child("posts/").orderByChild("userId").equalTo(id);
    var event = await _query.once();
    var result = event.snapshot.children;

    print(result.length);

    for(var item in result){
      items.add(Post.fromJson(Map<String,dynamic>.from(item.value as Map)));
    }
    print(items.length);
    return items;

  }

  static Future<void> deletePost({required String key}) async {
    await _database.child("posts/").child(key).remove();
  }

  static Future<void> updatePost({required String key, required Post post}) async {
    await _database.child("posts/").child(key).update(post.toJson());
  }

}