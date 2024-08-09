import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser{
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  MyUser(
      {required this.username,
        required this.uid,
        required this.photoUrl,
        required this.email,
        required this.bio,
        required this.followers,
        required this.following}
      );

  Map<String,dynamic> toJson() =>{
    'username': username,
    'uid': uid,
    'email': email,
    'downUrl': photoUrl,
    'bio':bio,
    'followers': followers,
    'following': following,
  };
  
  static MyUser fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data()! as Map<String,dynamic>;
    try{
      return MyUser(
        username: snap['username'],
        uid: snap['uid'],
        photoUrl: snap['downUrl'],
        email: snap['email'],
        bio: snap['bio'],
        followers: snap['followers'],
        following: snap['following'],
      );
    }catch(e){
      print('error converting');
      print('An error occurred: $e');
      throw e; // Re-throw the error after logging
    }
  }

}