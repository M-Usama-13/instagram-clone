import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post.dart';
import 'package:instagram_clone/screens/feed.dart';
import 'package:instagram_clone/screens/profile.dart';
import 'package:instagram_clone/screens/search.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItems = [
 // Center(child: Text('feed'),),
  Feed(),
  SearchScreen(),
  AddPost(),
  Text('notifications'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
];