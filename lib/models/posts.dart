
import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String postId;
  final String username;
  final String uid;
  final String profileUrl;
  final String postUrl;
  final String description;
  final uploadTime;
  final likes;

  Post({
    required this.postId,
    required this.username,
    required this.uid,
    required this.profileUrl,
    required this.postUrl,
    required this.description,
    required this.uploadTime,
    required this.likes
});



  Map<String,dynamic> toJson() =>{
    'postId': postId,
    'username': username,
    'uid': uid,
    'profileUrl': profileUrl,
    'imageUrl': postUrl,
    'description': description,
    'likes': likes,
    'uploadTime': uploadTime,
  };

  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String,dynamic>;
    return Post(
      postId: snap['postId'],
      username: snap['username'],
      uid: snap['uid'],
      profileUrl: snap['profileUrl'],
      postUrl: snap['imageUrl'],
      description: snap['description'],
      uploadTime: snap['uploadTime'],
      likes: snap['likes'],
    );
  }

}