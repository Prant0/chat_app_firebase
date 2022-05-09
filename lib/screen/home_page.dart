import 'package:chat_app/all_constants/brand_colors.dart';
import 'package:chat_app/all_model/popupChoice.dart';
import 'package:chat_app/all_providers/authProvider.dart';
import 'package:chat_app/screen/login_page.dart';
import 'package:chat_app/screen/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AuthProvider authProvider;
 // late HomeProvider homeProvider;
  late String currentuserId;
  bool isLoading=false;
  bool isWhite = true;

  int _limit=20;
  int _limitIncrement=20;
  String textSearch="";

  final GoogleSignIn googleSignIn=GoogleSignIn();
  final ScrollController listScrollController=ScrollController();

  List<PopupChoice> choices = <PopupChoice>[
    PopupChoice(title: "Settings", icon: Icons.settings),
    PopupChoice(title: "Sign out", icon: Icons.exit_to_app),
  ];

  Future<void> handleSignOut() async {
    authProvider.handleSignOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void onItemMenuPress(PopupChoice choice) {
    if (choice.title == "Sign out") {
      handleSignOut();
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }

  Widget buildPopUoMenu() {
    return PopupMenuButton<PopupChoice>(
      icon: Icon(Icons.more_vert, color: Colors.grey,),
      onSelected: onItemMenuPress,
      itemBuilder: (BuildContext context) {
        return choices.map((PopupChoice choice) {
          return PopupMenuItem<PopupChoice>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(choice.icon,
                    color: primaryColor,
                  ),
                  SizedBox(width: 10,),
                  Text(choice.title, style: TextStyle(
                      color:Colors.red
                  ),)
                ],
              ));
        }).toList();
      },
    );
  }

  void scrollListener(){
    if(listScrollController.offset>=listScrollController.position.maxScrollExtent && listScrollController.position.outOfRange){
      setState(() {
        _limit+=_limitIncrement;
      });
    }
  }

    @override
  void initState() {
    // TODO: implement initState
      authProvider=context.read<AuthProvider>();
     // homeProvider= context.read<AuthProvider>();
      if(authProvider.getUserFirebaseId()?.isNotEmpty==true){
        currentuserId=authProvider.getUserFirebaseId()!;
      }else{
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()),
            (Route<dynamic>route)=>false);
      }
      listScrollController.addListener(scrollListener);
      super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isWhite?Colors.white:Colors.black87,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isWhite?Colors.white:Colors.black87,
        leading: IconButton(
          onPressed: () {},
          icon: Switch(
            value: isWhite,
            onChanged: (value) {
              setState(() {
                isWhite = value;
              });
            },
            activeTrackColor: Colors.grey,
            activeColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            inactiveThumbColor: Colors.black54,
          ),
        ),
        actions: <Widget>[
          buildPopUoMenu(),
        ],
      ),

      body: Container(
        child: Column(
          children: [
            Text("This is Home Screen,", style: myStyles20(),)
          ],
        ),
      ),
    );
  }
}
