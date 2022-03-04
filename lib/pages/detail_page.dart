import 'dart:io';

import 'package:firbasenoteapp/pages/home_page.dart';
import 'package:firbasenoteapp/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../post_model/post_model.dart';
import '../services/hive_service.dart';
import '../services/rtdb_service.dart';

class DetailPage extends StatefulWidget {

  final Post? post;
  final String? postKey;
  const DetailPage({Key? key, this.post, this.postKey}) : super(key: key);
  static const String id = "/detail_page";
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? post;

  bool isLoading =false;
  bool isEditing =false;

  TextEditingController _contentcontroller = TextEditingController();
  TextEditingController _titlecontroller = TextEditingController();
   File? _image;
  final picker = ImagePicker();

  void _addPost() {

    String title = _titlecontroller.text.toString();
    String content = _contentcontroller.text.toString();
    if(title.isEmpty || content.isEmpty) return;
    _apiUploadImage(title,content);
    setState(() {
      isLoading = true;
    });
  }

  void editPost() {
    widget.post!.title = _titlecontroller.text.trim().toString();
    widget.post!.content = _contentcontroller.text.trim().toString();
   widget.post!.img_url = _image != null ?  _image!.path.toString() : widget.post!.img_url;

    if (_titlecontroller.text.trim().toString().isEmpty || _contentcontroller.text.trim().toString().isEmpty || _image.toString().isEmpty) {
      return ;
    }
    _apiEditPost(key: widget.postKey!, post: widget.post!);
  }




  void _apiUploadImage(String title,String content){
    StoreService.uploadImage( _image).then((imgUrl) => {

      _apiAddPost(title,content,imgUrl),

    });
  }

  void _apiEditPost({required String key, required Post post}) async {
    await StoreService.uploadImage(_image);
    await RTDGService.updatePost(key: key, post: post);
    Navigator.pop(context);
  }


  void _apiAddPost( String title,String content,String? imgUrl) async{
    String id = await HiveDB.loadU();
    RTDGService.addPost(Post(userId: id, content: content, title: title,img_url: imgUrl)).then((response) => {
      _resAddPost(),

    });
  }

  void _resAddPost() {
    Navigator.of(context).pop({'data' : 'done'});
  }


  _getImage() async{
 final pickedFile = await picker.pickImage(source:ImageSource.gallery);

 setState(() {
   if(pickedFile != null){
     _image = File(pickedFile.path);
   }else{
     print('No image selected.');
   }
 });

   isLoading = false;
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.post != null) {
      setState(() {
        isEditing = true;
        _titlecontroller.text = widget.post!.title;
        _contentcontroller.text = widget.post!.content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: widget.post == null ? Text("Add post",style: TextStyle(color: Colors.black,fontSize: 22),):Text("Update post")
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [

              GestureDetector(
                onTap: _getImage,
                child: SizedBox(
                  height: 100,
                  width: 100,
                 child: _image != null ? Image.file(_image!) : Image.asset("assets/images/img_1.png") ,
                )
              ),


              const SizedBox(height: 15,),

              ////  TITLE
              TextField(
                controller: _titlecontroller,
                decoration: const InputDecoration(
                  hintText: "Title"
                ),
              ),

              const SizedBox(height: 15,),

              ///////CONTENT
              TextField(
                controller: _contentcontroller,
                decoration: const InputDecoration(
                    hintText: "Content"
                ),
              ),

              const SizedBox(height: 15,),

              //////ADD BUTTON
              SizedBox(
                width: double.infinity,
                height: 45,
                child: MaterialButton(
                  onPressed: isEditing ? editPost : _addPost,
                  color: Colors.black54,
                  child: Text(isEditing ? "Edit" : "Add", style: const TextStyle(color: Colors.white),),
                ),
              ),
              isLoading
                  ? CircularProgressIndicator(
                color: Colors.black38,
              )
                  : const SizedBox.shrink(),


            ],
          ),
        ),
      ),

    );
  }
}