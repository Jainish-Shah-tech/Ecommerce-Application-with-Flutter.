import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  static const NAME = "name";
  static const CITY = "city";
  static const NUMBER = "number";
  static const ADDRESS = "address";
  static const COUNTRY = "country";
  static const STATE = "state";
  static const POSTALCODE = "postalcode";
  static const UID = "UID";

  String _uid;
  String _name;
  String _city;
  String _address;
  String _country;
  String _state;
  String _number;
  String _postalcode;

  String get uid => _uid;

  String get name => _name;

  String get city => _city;

  String get address => _address;

  String get country => _country;

  String get state => _state;

  String get number => _number;

  String get postalcode => _postalcode;

  AddressModel.fromSnapshot(DocumentSnapshot snapshot) {
    _uid = snapshot.data()[UID];
    _name = snapshot.data()[NAME];
    _city = snapshot.data()[CITY];
    _address = snapshot.data()[ADDRESS];
    _country = snapshot.data()[COUNTRY];
    _state = snapshot.data()[STATE];
    _number = snapshot.data()[NUMBER];
    _postalcode = snapshot.data()[POSTALCODE];
  }

  AddressModel.fromMap(Map data) {
    _uid = data[UID];
    _name = data[NAME];
    _city = data[CITY];
    _address = data[ADDRESS];
    _country = data[COUNTRY];
    _state = data[STATE];
    _number = data[NUMBER];
    _postalcode = data[POSTALCODE];
  }

  Map<String, dynamic> toMap() {
    return {
      UID: _uid,
      NAME: _name,
      CITY: _city,
      ADDRESS: _address,
      COUNTRY: _country,
      STATE: _state,
      NUMBER: _number,
      POSTALCODE: _postalcode
    };
  }
}
