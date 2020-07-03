import 'package:flutter/material.dart';
import 'package:flutterdrwableex/model/Contacts.dart';
import 'package:flutterdrwableex/navigationdrawer/ContactDrawer.dart';
import 'package:flutterdrwableex/screens/ContactDetail.dart';
import 'package:flutterdrwableex/screens/ContactList.dart';
import 'package:flutterdrwableex/screens/FavoriteContactList.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }

}
class MyAppState extends State<MyApp>{
  int index = 0;
  List<Widget> list = [ContactList(), FavoriteContactList(), ];//ContactDetail(Contacts('', '', 2,"",""), 'Add Contact')

  List<String> screenList = ['Contact List', "Favorite List"];//"Add Contact"
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(screenList[index]),
        ),
        body: list[index],
        drawer: ContactDrawer(
          selectContactDrawer: (ctx, i) {
            setState(() {
              index = i;
              Navigator.pop(ctx);
            });
          },
        ),
      ),
    );
  }
}