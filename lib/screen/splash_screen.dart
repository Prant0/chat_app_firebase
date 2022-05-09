
import 'package:chat_app/all_constants/brand_colors.dart';
import 'package:chat_app/all_providers/authProvider.dart';
import 'package:chat_app/screen/home_page.dart';
import 'package:chat_app/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3),(){
      checkSignIn();
    });
    super.initState();
  }
  void checkSignIn()async{
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn=await authProvider.isLoggedIn();
    if(isLoggedIn){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      return;
    }else{
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>LoginPage()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is splash Screen,",style: myStyles20(),),

            Container(child: CircularProgressIndicator(),)
          ],
        ),
      ),
    );
  }
}
