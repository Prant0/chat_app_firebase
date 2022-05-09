import 'package:chat_app/all_constants/brand_colors.dart';
import 'package:chat_app/all_providers/authProvider.dart';
import 'package:chat_app/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {

    AuthProvider authProvider=Provider.of<AuthProvider>(context);
    switch(authProvider.status){
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in failed");
        break;

      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;

      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;

      default:
        break;
    }
    return Scaffold(
      appBar: AppBar(),

      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is Login Screen,",style: myStyles20(),),

            SizedBox(height: 100,),
            InkWell(
              onTap: ()async{
                bool isSuccess=await authProvider.handelSignIn();
                if(isSuccess){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));

                }
              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.blue,
                child: Text("Google   Login"),
              ),
            ),

            Positioned(child: authProvider.status==Status.authenticating? CircularProgressIndicator():SizedBox.shrink()),

          ],
        ),
      ),
    );
  }
}
