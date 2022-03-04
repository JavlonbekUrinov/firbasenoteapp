import 'package:firbasenoteapp/pages/detail_page.dart';
import 'package:firbasenoteapp/services/hive_service.dart';
import 'package:firbasenoteapp/services/rtdb_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../post_model/post_model.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "/home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> items = [];

  Future _openDetailPage() async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage();
    }));
    if (results != null && results.containsKey("data")) {
      print(results["data"]);
      _apiGEtPost();
    }
  }

  _apiGEtPost() async {
    var id = await HiveDB.loadU();
    RTDGService.getPost(id).then((posts) => {print(posts), _respPosts(posts)});
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Fluttertoast.showToast(
        msg: "Succesfull",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0);
    _apiGEtPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
           Column(
             children: [
               Container(
                 height: 120,
                 width: 120,
                 child: ClipRRect(

                   child: Image.asset("assets/images/img_5.png",fit: BoxFit.cover,),
                   borderRadius: BorderRadius.circular(60),
                 ),
               ),

               SizedBox(height: 10,),
               Text("My Note",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)
             ],
           ),
            SizedBox(
              height: 70,
            ),
            MaterialButton(
              onPressed: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            MaterialButton(
              onPressed: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(Icons.language),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Language",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            MaterialButton(
              onPressed: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            MaterialButton(
              onPressed: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(Icons.language),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Language",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),

            Divider(
              thickness: 2,
            ),
            MaterialButton(
              onPressed: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Icon(Icons.language),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Language",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ),





            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: MaterialButton(
                  onPressed: () {
                    AuthService.deleteUser(context);
                    AuthService.signOutUser(context);
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black54,
        elevation: 0,
        title: Text(
          "All posts",
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                AuthService.signOutUser(context);
              },
              color: Colors.black,
              icon: Icon(Icons.logout)),

        ],
      ),
      body: FirebaseAnimatedList(
        physics: BouncingScrollPhysics(),
          query: FirebaseDatabase.instance.ref().child("posts/"),
          itemBuilder:
              (_, DataSnapshot snapshot, Animation<double> animation, int x) {
            Post post =
                Post.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
            String key = snapshot.key!;

            print(post.toJson());
            return itemOfPost(key, post);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.grey.shade600,
      ),
    );
  }

  Widget itemOfPost(String key, Post post) {
    return GestureDetector(
        onTap: () {
      showModalBottomSheet(
          isDismissible: true,
          // isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              )),
          context: context,
          builder: (context) {
            return buttonFNC(context, key, post);
          });
    },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Container(
          // color: Colors.red,

          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade400,
                Colors.grey.shade300,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  child: post.img_url != null
                      ? Image.network(post.img_url!, fit: BoxFit.cover)
                      : Image.asset("assets/images/img_3.png"),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post.content,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget buttonFNC(BuildContext context, String key, Post post) {
    return Container(
        height: 370,
        color: Colors.black26,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            ///// img and thier content or title
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          child: post.img_url != null
                              ? Image.network(post.img_url!, fit: BoxFit.cover)
                              : Image.asset("assets/images/img_3.png"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              post.content,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /////DELETE BUTTON
            SizedBox(
              height: 50,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  color: Colors.black45, borderRadius: BorderRadius.circular(30)),
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: MaterialButton(
                  onPressed: () async {
                    await RTDGService.deletePost(key: key);
                    Navigator.pop(context);
                  },
                  child: Center(
                      child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
            ),

            ////////UPDATE BUTTON
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  color: Colors.blueGrey, borderRadius: BorderRadius.circular(30)),
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.push(context,  MaterialPageRoute(builder: (context) =>  DetailPage(postKey: key, post: post)),);
                  },
                  child: Center(
                      child: Text(
                    "Update",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ))),
            ),


            ////////CLOSE BUTTON
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                  color: Colors.grey, borderRadius: BorderRadius.circular(30)),
              height: 50,
              width: MediaQuery.of(context).size.width - 50,
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                      child: Text(
                        "Close",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
            ),
          ],
        ));
  }
}
