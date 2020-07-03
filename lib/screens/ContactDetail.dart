import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdrwableex/database/DatabaseHelper.dart';
import 'package:flutterdrwableex/model/Contacts.dart';
import 'package:image_picker/image_picker.dart';

class ContactDetail extends StatefulWidget {
  final String appBarTitle;
  final Contacts contacts;

  ContactDetail(this.contacts, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _ContactDetailState(this.contacts, this.appBarTitle);
  }
}

class _ContactDetailState extends State<ContactDetail> {
  DatabaseHelper helper = DatabaseHelper();
  String appTitle;
  Contacts contacts;
  File _image;
  String path;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController landlineController = TextEditingController();

  _ContactDetailState(this.contacts, this.appTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    if (contacts.imagePath.length > 3) {
      _image = File(contacts.imagePath);
    } else {
      _image = null;
    }
    nameController.text = contacts.name;
    mobileController.text = contacts.mobile;
    landlineController.text = contacts.landline;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: GestureDetector(
                    child: _image == null
                        ? CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                AssetImage('images/camera.png'))
                        : CircleAvatar(
                            radius: 70, backgroundImage: FileImage(_image)),
                    onTap: () {
                      debugPrint('On Image Tap');
                      _openCamera();
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: nameController,
                  style: textStyle,
                  maxLines: 1,
                  onChanged: (value) {
                    debugPrint("Something changed in Title Text Field");
                    updateName();
                  },
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: mobileController,
                  style: textStyle,
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    debugPrint('Something changed in Description Text Field');
                    updateMobile();
                  },
                  decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: landlineController,
                  style: textStyle,
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    debugPrint('Something changed in Description Text Field');
                    updatelandline();
                  },
                  decoration: InputDecoration(
                      labelText: 'Landline',
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          changeButtonText(),
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            if (_validation()) {
                              _save();
                            }
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: contacts.favorite == 1
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight,
                        textColor:
                            contacts.favorite == 1 ? Colors.white : Colors.grey,
                        child: Text(
                          'Favorite',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Favorite button clicked");
                            if (contacts.favorite == 1) {
                              contacts.favorite = 2;
                            } else {
                              contacts.favorite = 1;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  changeButtonText(){
    if(contacts.id != null){
      return "UPDATE";
    }else{
      return "SAVE";
    }
  }
  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void updateName() {
    contacts.name = nameController.text;
  }

  bool _validation() {
    if (contacts.name.isEmpty) {
      _showAlertDialog('Name cannot be empty', 'Please enter Name');
      return false;
    }
    if (contacts.mobile.isEmpty) {
      _showAlertDialog(
          'Mobile number cannot be empty', 'Please enter Mobile number');
      return false;
    }
    if (contacts.landline.isEmpty) {
      _showAlertDialog(
          'Landline number cannot be empty', 'Please enter Landline number');
      return false;
    }
    if (contacts.landline.length != 10) {
      _showAlertDialog(
          'Landline number invalid', 'Please enter valid Landline number');
      return false;
    }
    if (contacts.mobile.length != 10) {
      _showAlertDialog(
          'Mobile number invalid', 'Please enter valid Mobile number');
      return false;
    }
    if (_image == null) {
      _showAlertDialog('Please select Image', 'Please click Image');
      return false;
    }
    return true;
  }

  // Update the description of Note object
  void updateMobile() {
    contacts.mobile = mobileController.text;
  }

  void updatelandline() {
    contacts.landline = landlineController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    //contactModel.landline = "landline number";
    //contactModel.imagePath = _image.path;
    int result;
    debugPrint("contact details are $contacts");
    if (contacts.id != null) {
      // Case 1: Update operation
      result = await helper.updateContact(contacts);
      debugPrint("id not null");
    } else {
      // Case 2: Insert Operation
      debugPrint("id null");
      result = await helper.insertContact(contacts);
    }
    debugPrint("id $result");
    if (result != 0) {
      // Success
      debugPrint("Contact Saved Successfully");
      _showAlertDialog('Status', 'Contact Saved Successfully');
    } else {
      // Failure
      debugPrint("Contact didnot Saved Successfully");
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _openCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      contacts.imagePath = _image.path;
    });
  }
}
