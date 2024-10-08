import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'type to search',
            ),
             onFieldSubmitted: (String s){
              setState((){
                isShowUsers = true;
              });
              print(s);
             },
          ),
        ),
      ),
      body:  isShowUsers ?
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('users')
            .where('username', isGreaterThanOrEqualTo: _searchController.text)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else{

          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uid: snapshot.data!.docs[index]['uid']
                      )
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    // backgroundImage: NetworkImage(
                    //     snapshot.data!.docs[index]['photoUrl']
                    // ),
                  ),
                  title: Text(
                      snapshot.data!.docs[index]['username']
                  ),
                ),
              );
            },
          );
        }
      ):
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
          builder: (context, snapshot){
            return StaggeredGridView.countBuilder(
          crossAxisCount: 3,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context,index) {
            return Image.network((snapshot.data! as dynamic).docs[index]['imageUrl']);
            },
             staggeredTileBuilder: (int index) {
            return
              StaggeredTile.count((index % 7 == 0)?2:1, (index % 7 == 0)?2:1);
             },
          mainAxisSpacing: 8,
        );
      })
    );

    }
}
