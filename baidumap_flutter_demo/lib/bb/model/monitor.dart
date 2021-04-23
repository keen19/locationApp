class Monitor {
  String _monitorName;
  String _sex;
  String _age;

  Monitor(this._monitorName, this._age, this._sex);

  @override
  String toString() {
    return 'Monitor{monitorName: $_monitorName, sex: $_sex, age: $_age}';
  }

  String get monitorName => _monitorName;

  set monitorName(String value) {
    _monitorName = value;
  }


  String get sex => _sex;

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  set sex(String value) {
    _sex = value;
  }
}

