import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactDrawer extends StatelessWidget {
  final Function selectContactDrawer;

  ContactDrawer({this.selectContactDrawer});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Rajesh Yadav"),
            accountEmail: Text("rajesh.kumar07@nagarro.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                "R",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.yellow,),
            title: Text("Home", style: TextStyle(fontSize: 25.0),),
            onTap: (){
              selectContactDrawer(context, 0);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.red,),
            title: Text("Favorite List", style: TextStyle(fontSize: 25.0),),
            onTap: (){
              selectContactDrawer(context, 1);            },
          ),
         /* ListTile(
            leading: Icon(Icons.contacts),
            title: Text("Add new Contact",style:TextStyle(fontSize: 25.0)),
            onTap: (){
              selectContactDrawer(context, 2);
            },
          )*/
        ],
      ),
    );
  }
}
