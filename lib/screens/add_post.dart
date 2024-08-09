import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/storage_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/utils.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  bool isLoading = false;
  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Create a post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text('Take a Photo'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file =  await pickImage(ImageSource.camera);
              setState((){
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text('Choose From Gallery'),
            onPressed: () async {
              Navigator.of(context).pop();
              Uint8List file =  await pickImage(ImageSource.gallery);
              setState(() {
                _file = file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: const Text('Cancel',style: TextStyle(color: Colors.redAccent),),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ],

      );
    });
  }
  postImage({
    required String uid,
    required String username,
    required String profileImage,
}) async {
    String res = 'pending';
    try{
      setState(() {
        isLoading = true;
      });
      res =  await FirestoreMethods().uploadPost(
          description: _descriptionController.text,
          username: username,
          uid: uid,
          profileImage: profileImage,
          file: _file!
      );
      if(res == 'success') {
        showShowSnackBar(context, 'posted successfully');
        setState(() {
          isLoading = false;
        });
        cleaImage();

      }
      else{
        showShowSnackBar(context, res);
        setState(() {
          isLoading = false;
        });
      }

    }catch(e){
      showShowSnackBar(context, e.toString());
    }
  }

  cleaImage(){
    setState((){
      _file = null;
    });
  }


  final TextEditingController _descriptionController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<UserProvider>(context).getUser;

    return _file == null ?
    Center(
      child: IconButton(
        icon: const Icon(Icons.upload),
        onPressed: () => _selectImage(context),
      ),
    ):
    Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: cleaImage,
        ),
        title: const Text('Post to'),
        actions: [
          TextButton(
            onPressed: () => postImage(uid: user.uid, username: user.username, profileImage: user.photoUrl),
            child: Text('Post',style: TextStyle(color: Colors.blueAccent[200]),),
          )
        ],
      ),
      body: Column(
        children: [
          isLoading
          ? const LinearProgressIndicator()
          : const Padding(padding: EdgeInsets.only(top: 0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'enter you caption',
                    border: InputBorder.none,

                  ),
                ),
              ),
              SizedBox(
                height: 55,
                width: 55,
                child: AspectRatio(
                  aspectRatio: 481/457,
                  child: Container(
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),

        ],
      ),
    );
  }
}
