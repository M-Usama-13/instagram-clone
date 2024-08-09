
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/posts.dart';
import 'package:instagram_clone/services/storage.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost({
    required String description,
    required String username,
    required String uid,
    required String profileImage,
    required Uint8List file,
  }) async {
    String res = "some error occurred";

    String postId = const Uuid().v1();
    try {
      print('commencing upload');
      String postUrl = await StorageMethods().uploadImageToStorage(
          'posts', file, true);
      Post post = Post(
          postId: postId,
          username: username,
          uid: uid,
          profileUrl: profileImage,
          postUrl: postUrl,
          description: description,
          uploadTime: DateTime.now(),
          likes: []
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      print('success');
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      List likes,
      String postId,
      String uid
      ) async{
   try{
     if(likes.contains(uid)) {
       await _firestore.collection('posts').doc(postId).update({
         'likes': FieldValue.arrayRemove([uid]),
       });
     }else{
       await _firestore.collection('posts').doc(postId).update({
         'likes': FieldValue.arrayUnion([uid]),
       });
     }
   }catch(e){
     print(e.toString());
   }
  }

  Future<void> postComment(String text, String postId, String uid,String username, String profileUrl) async {
    try{
      String commentId = const Uuid().v1();
      await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
          {
            'text': text,
            'uid': uid,
            'username':username,
            'profileUrl': profileUrl,
            'commentId': commentId,
            'DataPublished': DateTime.now()
          });
      print('success');
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> deletePost(String postId) async{
    try{
     await _firestore.collection('posts').doc(postId).delete();

    }catch(e){
      print(e.toString());
    }
  }


}