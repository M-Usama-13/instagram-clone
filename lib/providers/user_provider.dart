
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/services/auth.dart';

class UserProvider with ChangeNotifier{
  final AuthService _authService = AuthService();
  MyUser? _user;

  MyUser get getUser => _user!;

  Future<void> refreshUserData() async {
    try {
      print('step 1');
      MyUser user = await _authService.getUserDetails();
      _user = user;
      print('step 2');
      notifyListeners();
    }catch(e){
      print(e.toString());
      print('huntututu tarara');
    }
  }
}