

import 'package:chat_app/all_constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserChat{
  String id;
  String photoUrl;
  String nickName;
  String aboutMe;
  String phoneNumber;
  UserChat({
    required this.id,
  required this.aboutMe,
  required this.phoneNumber,
  required this.photoUrl,
  required this.nickName,
});

    Map<String, String>toJson(){
      return{
      FireStoreConstants.nickName:nickName,
      FireStoreConstants.aboutMe:aboutMe,
      FireStoreConstants.photoUrl:photoUrl,
      FireStoreConstants.phoneNumber:phoneNumber,
      };

    }

    factory UserChat.fromDocument(DocumentSnapshot doc){
      String aboutMe="";
      String photoUrl="";
      String nickName="";
      String phoneNumber="";
      try{
        aboutMe=doc.get(FireStoreConstants.aboutMe);
  }catch(e){}
  try{
  photoUrl=doc.get(FireStoreConstants.photoUrl);
  }catch(e){}
  try{
  nickName=doc.get(FireStoreConstants.nickName);
  }catch(e){}
  try{
  phoneNumber=doc.get(FireStoreConstants.phoneNumber);
  }catch(e){}
  return UserChat(
  id: doc.id,
  aboutMe: aboutMe,
  phoneNumber: phoneNumber,
  photoUrl: photoUrl,
  nickName: nickName);

}
}