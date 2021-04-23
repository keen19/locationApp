import 'monitor.dart';
class User{
  String _username;
  String _address;
  Monitor _monitor;
  double _latitude;
  double _longitude;

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  Monitor get monitor => _monitor;

  set monitor(Monitor value) {
    _monitor = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  User(this._username, this._address, this._monitor, this._latitude,
      this._longitude);


  //User(this._username, this._address, this._monitor);

  @override
  String toString() {
    return 'User{_username: $_username, _address: $_address, _monitor: $_monitor, _latitude: $_latitude, _longitude: $_longitude}';
  }
}
