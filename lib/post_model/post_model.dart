class Post {
 late String userId;
 late String title;
 late String content;
  String? img_url;

  Post({required this.userId, required this.title, required this.content, this.img_url});

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        title = json['title'],
        content = json['content'],
        img_url = json['img_url'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'content': content,
        'img_url': img_url,
      };
}
