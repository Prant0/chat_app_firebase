import 'package:chat_app/all_constants/app_constants.dart';
import 'package:chat_app/all_providers/authProvider.dart';
import 'package:chat_app/all_providers/setting_provider.dart';
import 'package:chat_app/screen/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isWhile = false;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences preferences=await SharedPreferences.getInstance();
  runApp(  MyApp(preferences: preferences,));
}

class MyApp extends StatelessWidget {

  final SharedPreferences  preferences;
  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage=FirebaseStorage.instance;

  MyApp({required this.preferences});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_)=>AuthProvider(sharedPreferences: this.preferences, firebaseFirestore: this.firebaseFirestore, firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn())),
        Provider<SettingProvider>(create: (_)=>SettingProvider(
            preferences: this.preferences,
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage)),


      ],
      child: MaterialApp(
        title: AppConstants.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
       home: SplashScreen(),
       debugShowCheckedModeBanner: false,
       // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

