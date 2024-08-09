import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/storage.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');



Future<MyUser> getUserDetails() async {
  User currentUser = _auth.currentUser!;
  print(currentUser.uid);
  DocumentSnapshot snap = await userCollection.doc(currentUser.uid).get();
  print(snap.get('username'));
  print('success');
  return MyUser.fromSnapshot(snap);
}

// signUp with email and password
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file
  }) async{
    String sts = 'error';
    try{
      if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){
       UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
       String downUrl  = await StorageMethods().uploadImageToStorage('profilePics', file!, false);
       MyUser _user =  MyUser(
           username: username,
           uid: res.user!.uid,
           photoUrl: downUrl,
           email: email,
           bio: bio,
           followers: [],
           following: []
       );
       await userCollection.doc(res.user!.uid).set(_user.toJson());

         sts = 'success';
      }
    }catch(e){
      sts =  e.toString();
    }
    return sts;
  }

  //login with email and password
  Future<String> logInUser({required String email, required String password}) async {

    String res = 'sds';
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';

    }catch(e){
      res = e.toString();
    }
    return res;
  }

  //signOut function
  Future<void> signOut() async{
    await _auth.signOut();
  }

}