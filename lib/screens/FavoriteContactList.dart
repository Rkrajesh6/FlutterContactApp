import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterdrwableex/database/DatabaseHelper.dart';
import 'package:flutterdrwableex/model/Contacts.dart';
import 'package:sqflite/sqflite.dart';

import 'ContactDetail.dart';

class FavoriteContactList extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return FavoriteContactListState();
  }

}

class FavoriteContactListState extends State<FavoriteContactList>{

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Contacts> contactList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (contactList == null) {
      contactList = List<Contacts>();
      updateListView();
    }

    return Scaffold(

      body: getContactListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Contacts('', '', 2,"",""), 'Add Contact');
        },

        tooltip: 'Add Contact',

        child: Icon(Icons.add),

      ),
    );
  }


  ListView getContactListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return GestureDetector(
          child: Card(
            elevation: 5.0,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundImage:
                      FileImage(File(this.contactList[position].imagePath)),
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Flexible(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text(
                                this.contactList[position].name,
                                style: titleStyle,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text(
                                this.contactList[position].landline,
                                style: titleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Container(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Text(
                                this.contactList[position].mobile,
                                style: titleStyle,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                            height: 5.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: setFavoriteImage(position),
                          )
                        ],
                      )),
                  Container(
                    width: 5.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        _delete(context, contactList[position]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            debugPrint("ListTile Tapped");
            navigateToDetail(this.contactList[position], 'Edit Contact');
          },
        );
      },
    );
  }

  /**
   * this mehtod is used to show he favorite item with color code.
   */
  setFavoriteImage(int position) {
    if (this.contactList[position].favorite == 1) {
      return Icon(Icons.favorite, color: Colors.red);
    } else {
      return Icon(
        Icons.favorite,
        color: Colors.grey,
      );
    }
  }

  void _delete(BuildContext context, Contacts note) async {

    int result = await databaseHelper.deleteContact(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Contact Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Contacts note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ContactDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<Contacts>> noteListFuture = databaseHelper.getFavoriteContactList();
      noteListFuture.then((noteList) {
        setState(() {
          this.contactList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}