import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/screens/comments.dart';
import 'package:instagram_clone/services/storage_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;
  @override
  void initState(){
    super.initState();
    getComments();
  }
  void getComments()async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
    commentLen = querySnapshot.docs.length;
    setState(() {
      commentLen = querySnapshot.docs.length;
    });

  }
  @override
  Widget build(BuildContext context) {
    final MyUser user =  Provider.of<UserProvider>(context).getUser;
    FirestoreMethods  fireMethods =  FirestoreMethods();

    return Container(
      color: mobileBackgroundColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  widget.snap['profileUrl']
                ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.snap['username']}',
                          style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
              ),
              ),
              IconButton(
                  onPressed: (){
                    showDialog(context: context, builder: (context)=> Dialog(
                      child: ListView(
                        padding: const EdgeInsets.only(right: 10),
                        shrinkWrap: true,
                        children: [
                          'Delete'
                        ].map((e) => InkWell(
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              child: Text(e),
                            ),
                          ),
                          onTap: (){
                            FirestoreMethods().deletePost(widget.snap['postId']);
                          },
                        ),
                        ).toList(),
                      ),
                    ));
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
          GestureDetector(
            onDoubleTap: () async{
               await fireMethods.likePost(widget.snap['likes'], widget.snap['postId'], user.uid);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                height: MediaQuery.of(context).size.height*0.33,
                width: double.infinity,
                child: Image.network(
                  widget.snap['imageUrl'],
                fit: BoxFit.cover,)
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity:  isLikeAnimating? 1:0,
                  child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 400),
                      onEnd: (){
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child:  const Icon(Icons.favorite , color: Colors.white, size: 140,),
                      ),
                )
            ]
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  duration: const Duration(milliseconds: 400),
                  onEnd: () {
                  setState((){
                    isLikeAnimating = false;
                  });
                  },
                  child: IconButton(
                      onPressed: () async {
                        await fireMethods.likePost(widget.snap['likes'], widget.snap['postId'], user.uid);
                  },
                      icon: widget.snap['likes'].contains(user.uid)?
                      const Icon(Icons.favorite, color: Colors.red,):
                      const Icon(Icons.favorite_border_outlined),
                  ),
              ),
              IconButton(
                  onPressed: (){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                CommentScreen(
                                  snap: widget.snap,
                                ),
                        ),
                    );
                  }, icon: const Icon(Icons.mode_comment_outlined)),
              IconButton(onPressed: (){}, icon: const Icon(Icons.send)),
              Expanded(child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: (){},
                  icon: const Icon(Icons.bookmark_border),
                ),
              ))
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.w600),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                  style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap['username'],
                          style: const TextStyle( fontWeight: FontWeight.bold),
                        ),   TextSpan(
                          text: ' ${widget.snap['description']}',
                        ),
                      ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CommentScreen(
                      snap: widget.snap,
                    )));

                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      'view all $commentLen comments'
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    DateFormat.yMMMd().format(  widget.snap['uploadTime'].toDate(),),
                    style: const TextStyle(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
