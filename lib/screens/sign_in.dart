import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/register.dart';
import 'package:instagram_clone/services/auth.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/decorations.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../responsive/mobile_screen.dart';
import '../responsive/responsive_screen.dart';
import '../responsive/web_screen.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  bool isLoading =  false;
  void login() async {
    setState((){
      isLoading = true;
    });
    print('commencing');
   String res =  await _auth.logInUser(email: email, password: password);
   print(res);
   if( res != 'success'){
     showShowSnackBar(context, res);
   }
   else if(res == 'success'){
     Navigator.of(context).pushReplacement(MaterialPageRoute(
         builder: (context)=> const  ResponsiveLayout(
             webScreenLayout: WebLayout(),
             mobileScreenLayout: MobileLayout(),
         ),
     )
     );
   }
  }
  final GlobalKey<FormState> _key = GlobalKey();
  void navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Register()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(flex: 1,child: Container(),),
            const SizedBox(height: 65,),
            Form(
              child: Column(
                children: [
                  SvgPicture.asset(
                    'lib/assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  SizedBox(height: 64,),
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
                            email = val;
                          });
                        },
                        decoration: textInputDecorator.copyWith(hintText: 'email')
                    ),
                  ),
                  const SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                        validator: (val){
                          if(val ==  null || val.isEmpty){
                            return 'please enter your password';
                          }
                          return null;
                        },
                        onChanged: (val){
                          setState((){
                            password = val;
                          });
                        },
                        obscureText: true,
                        decoration: textInputDecorator.copyWith(hintText: 'password')

                    ),
                  ),
                  const SizedBox(height: 25,),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    width: double.infinity,
                    child: ElevatedButton(onPressed: login,
                      child: isLoading? const Center(child: CircularProgressIndicator(
                        color: primaryColor,
                      ),): const Text('LogIn',
                        style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.7),),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Dont have an account create one now:'),
                      TextButton(onPressed: navigateToSignUp, child: const Text('SignUp')
                      )
                    ],
                  )
                ],
              ),
            ),
            Flexible(flex: 1,child: Container(),)
          ],
        ),
      ),
    );
  }
}

