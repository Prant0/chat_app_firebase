import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider{


  final SharedPreferences preferences;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  SettingProvider({
    required this.firebaseStorage,
  required this.firebaseFirestore,
  required this.preferences,
});

  String ? getPref(String key){
    return preferences.getString(key);
  }

  Future<bool> setPref(String key,value)async{
    return await preferences.setString(key, value);
  }

  UploadTask uploadTask(File image,String fileName){
    Reference reference=firebaseStorage.ref().child(fileName);
    UploadTask uploadTask=reference.putFile(image);
    return uploadTask;
  }

  Future <void> uploadDataFirestore(String collectionPath,path,Map<String,String > dataneedUpdate){
    return firebaseFirestore.collection(collectionPath).doc(path).update(dataneedUpdate);
  }

}