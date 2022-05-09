import 'package:chat_app/all_constants/app_constants.dart';
import 'package:chat_app/all_model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum Status{
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateCanceled,
}

class AuthProvider extends ChangeNotifier{
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences sharedPreferences;
  Status _status=Status.uninitialized;
  Status get status=>_status;
  AuthProvider({
    required this.sharedPreferences,
  required this.firebaseFirestore,
  required this.firebaseAuth,
    required this.googleSignIn,
});
  
  String ? getUserFirebaseId(){
    return sharedPreferences.getString(FireStoreConstants.id);
  }

  Future<bool> isLoggedIn()async{
    bool isLoggedIn=await googleSignIn.isSignedIn();
    if(isLoggedIn && sharedPreferences.getString(FireStoreConstants.id)?.isNotEmpty==true ){
      return true;
    }else{
      return false;
    }
  }
  Future<bool> handelSignIn()async{
    _status=Status.authenticating;
    notifyListeners();
    GoogleSignInAccount? googleUser =await googleSignIn.signIn();
    if(googleUser!=null){
      GoogleSignInAuthentication ? googleAuth=await googleUser.authentication;
      final AuthCredential credential=GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken:  googleAuth.idToken,
      );
      User? firebaseUser=(await firebaseAuth.signInWithCredential(credential)).user;
      if(firebaseUser!=null){
        final QuerySnapshot result= await firebaseFirestore.collection(FireStoreConstants.pathUserCollection).
    where(FireStoreConstants.id,isEqualTo: firebaseUser.uid).
    get();
        final List<DocumentSnapshot> document =result.docs;
        if(document.length==0){
          firebaseFirestore.collection(FireStoreConstants.pathUserCollection).doc(firebaseUser.uid).set(
              {
                FireStoreConstants.nickName:firebaseUser.displayName,
                FireStoreConstants.photoUrl:firebaseUser.photoURL,
                FireStoreConstants.id:firebaseUser.uid,
                "createdAt":DateTime.now().millisecondsSinceEpoch.toString(),
                FireStoreConstants.chattingWith:null,
              });
          User? currentUser=firebaseUser;
          await sharedPreferences.setString(FireStoreConstants.id, currentUser.uid);
          await sharedPreferences.setString(FireStoreConstants.nickName, currentUser.displayName ?? "");
          await sharedPreferences.setString(FireStoreConstants.photoUrl, currentUser.photoURL ?? "");
          await sharedPreferences.setString(FireStoreConstants.phoneNumber, currentUser.phoneNumber ?? "");
        }
        else{
          DocumentSnapshot documentSnapshot=document[0];
          UserChat userChat= UserChat.fromDocument(documentSnapshot);
          await sharedPreferences.setString(FireStoreConstants.id, userChat.id);
          await sharedPreferences.setString(FireStoreConstants.nickName, userChat.nickName ?? "");
          await sharedPreferences.setString(FireStoreConstants.photoUrl, userChat.photoUrl ?? "");
          await sharedPreferences.setString(FireStoreConstants.aboutMe, userChat.aboutMe ?? "");
          await sharedPreferences.setString(FireStoreConstants.phoneNumber, userChat.phoneNumber ?? "");
        }
        _status=Status.authenticated;
        notifyListeners();
        return true;
      }
      else{
        _status=Status.authenticateError;
        notifyListeners();
        return false;
      }
    }else{
      _status=Status.authenticateCanceled;
      notifyListeners();
      return false;
    }

  }


  Future<void> handleSignOut()async{
    _status=Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

  }
}