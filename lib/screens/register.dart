import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/screens/sign_in.dart';
import 'package:instagram_clone/services/auth.dart';

import '../responsive/mobile_screen.dart';
import '../responsive/responsive_screen.dart';
import '../responsive/web_screen.dart';
import '../utils/colors.dart';
import '../utils/decorations.dart';
import '../utils/utils.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Uint8List? _image;
  String email = '';
  String userName = '';
  String password = '';
  String bio = '';
  bool isLoading =  false;
  final AuthService _auth = AuthService();

  void navigateToSignIn(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SignIn(),
      ),
    );
  }
  Future signUp() async{
    setState((){
      isLoading = true;
    });
    String res = await _auth.signUpUser(
        email: email,
        password: password,
        username: userName,
        bio: bio,
        file: _image);

    setState((){
      isLoading = false;
    });
    if(res != 'success'){
      showShowSnackBar(context, res);
    }
    if(res == 'success'){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const  ResponsiveLayout(
              webScreenLayout: WebLayout(),
              mobileScreenLayout: MobileLayout(),
          ),
        )
      );
    }
  }
  final GlobalKey<FormState> _key = GlobalKey();
  Future selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Flexible(flex: 1,child: Container(),),
              SizedBox(height: 80,),
              SvgPicture.asset(
                'lib/assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 65,),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Colors.red,
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    backgroundColor: Colors.red,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              SizedBox(height: 25,),
              Form(
                key: _key,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                          validator: (val){
                            if(val ==  null || val.isEmpty){
                              return 'please enter a username';
                            }
                            return null;
                          },
                          onChanged: (val){
                            setState((){
                              userName =val;
                            });
                          },
                          decoration: textInputDecorator.copyWith(hintText: 'username')
                      ),
                    ),
                    const SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                          validator: (val){
                            if(val ==  null || val.isEmpty){
                              return 'please enter an email';
                            }
                            return null;
                          },
                          onChanged: (val){
                            setState((){
                              email =val;
                            });
                          },
                          decoration: textInputDecorator.copyWith(hintText: 'enter a email')
                      ),
                    ),
                    const SizedBox(height: 25,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                          validator: (val){
                            if(val ==  null || val.isEmpty){
                              return 'please enter your bio';
                            }
                            return null;
                          },
                          onChanged: (val){
                            setState((){
                              bio =val;
                            });
                          },
                          decoration: textInputDecorator.copyWith(hintText: 'your bio')
                      ),
                    ),
                    const SizedBox(height: 25,),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: TextFormField(
                          validator: (val){
                            if(val ==  null || val.isEmpty){
                              return 'please enter a password';
                            }
                            return null;
                          },
                          obscureText: true,
                          onChanged: (val){
                            setState((){
                              password =val;
                            });
                          },
                          decoration: textInputDecorator.copyWith(hintText: 'password')

                      ),
                    ),
                    const SizedBox(height: 25,),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUp,
                        child: isLoading ? const Center(child: CircularProgressIndicator(
                          color: primaryColor,
                        )):
                        const Text('Register',style: TextStyle(fontSize: 20,letterSpacing: 0.7),),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('already have and account:',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                        ),
                        ),
                        TextButton(onPressed: navigateToSignIn, child: Text('Login'))
                      ],
                    )
                  ],
                ),
              ),
              // Flexible(flex: 1,child: Container(),)
            ],
          ),
        ),
      ),
    );
  }
}

