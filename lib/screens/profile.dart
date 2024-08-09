import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/sign_in.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:instagram_clone/widgets/stat_column.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following  = 0;
  bool isFollowing = false;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    getData();
  }
  getData() async{
    try{
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      userData = userSnap.data()!;
      var postSnap = await FirebaseFirestore.instance.collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
      postLen = postSnap.docs.length;
      following = userSnap.data()!['following'].length;
      followers = userSnap.data()!['followers'].length;
      isFollowing = userSnap.data()!['followers'].contains(FirebaseAuth.instance.currentUser!.uid);

    }catch(e){
      showShowSnackBar(context, e.toString());
    }
    setState((){
      isLoading = false;
    });
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context)=>const SignIn(),
        )
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
        const Center(
          child: CircularProgressIndicator(),
        ):
    Scaffold(
      appBar: AppBar(
        title: Text(userData['username']),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              logout(context);
            },
          ),
        ],
        backgroundColor: mobileBackgroundColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              //main column
              children: [
                // first row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(
                        userData['downUrl']
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              StatColumn(num: postLen, label: 'posts'),
                              StatColumn(num: followers, label: 'followers'),
                              StatColumn(num: following, label: 'following'),
                            ],
                          ),

                          Row(
                            children: [
                              FirebaseAuth.instance.currentUser!.uid == widget.uid ?
                              FollowButton(
                                  backgroundColor: mobileBackgroundColor,
                                  borderColor: Colors.grey,
                                  text: 'Edit Profile',
                                  textColor: primaryColor,
                                function: (){},
                              ) : isFollowing ?
                              FollowButton(
                                backgroundColor: mobileBackgroundColor,
                                borderColor: Colors.grey,
                                text: 'following',
                                textColor: primaryColor,
                                function: (){},
                              ): FollowButton(
                                backgroundColor: blueColor,
                                borderColor: Colors.white,
                                text: 'follow',
                                textColor: primaryColor,
                                function: (){},
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              userData['username'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              userData['bio'],
            ),
          ),
        ],
      ),
    );
  }
}
