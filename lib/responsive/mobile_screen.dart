import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_var.dart';
import 'package:provider/provider.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {

  int _page = 0;
  late PageController pageController;
  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  navigationChanged(int page){
    pageController.jumpToPage(page);
  }
  onPageChanged(int page){
    setState((){
      _page = page;
    });
  }


  @override
  Widget build(BuildContext context) {
   // MyUser? user =  Provider.of<UserProvider>(context).getUser;

    return  Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items:  [
          BottomNavigationBarItem(icon: Icon(
            Icons.home,
            color: (_page ==  0 )? primaryColor : secondaryColor,
          ),
            label: '',
            backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(icon: Icon(
            Icons.search,
            color: (_page ==  1 )? primaryColor : secondaryColor,
          ),
              label: '',
              backgroundColor: primaryColor
          ),
          BottomNavigationBarItem(icon: Icon(
            Icons.add_circle,
            color: (_page ==  2 )? primaryColor : secondaryColor,
          ),
              label: '',
              backgroundColor: primaryColor
          ),BottomNavigationBarItem(icon: Icon(
            Icons.notifications,
            color: (_page ==  3 )? primaryColor : secondaryColor,
          ),
              label: '',
              backgroundColor: primaryColor
          ),BottomNavigationBarItem(icon: Icon(
            Icons.person,
            color: (_page ==  4 )? primaryColor : secondaryColor,
          ),
              label: '',
              backgroundColor: primaryColor
          ),
        ],
        onTap: navigationChanged,
        currentIndex: _page,
      ),

    );
  }
}
