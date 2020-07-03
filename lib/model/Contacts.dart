
class Contacts{

  int _id;
  String _name;
  String _mobile;
  String _landline;
  int _favorite;
  String _imagePath;

  Contacts(this._name, this._landline, this._favorite, this._mobile,this._imagePath);

  Contacts.withId(this._id, this._name, this._landline, this._favorite, this._mobile,this._imagePath);

  int get id => _id;

  String get name => _name;

  String get imagePath => _imagePath;

  int get favorite => _favorite;

  String get landline => _landline;

  String get mobile => _mobile;

  set id(int value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  set imagePath(String value) {
    _imagePath = value;
  }

  set favorite(int value) {
    _favorite = value;
  }

  set landline(String value) {
    _landline = value;
  }

  set mobile(String value) {
    _mobile = value;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['mobile'] = _mobile;
    map['favorite'] = _favorite;
    map['landline'] = _landline;
    map['imgpath'] = _imagePath;

    return map;
  }

  // Extract a Note object from a Map object
  Contacts.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._mobile = map['mobile'];
    this._favorite = map['favorite'];
    this._landline = map['landline'];
    this._imagePath = map['imgpath'];
  }
}