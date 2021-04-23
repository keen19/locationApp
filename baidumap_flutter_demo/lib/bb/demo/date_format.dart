//import 'package:date_format/date_format.dart';

import 'dart:async';

main(){
  int count=0;
  Timer.periodic(Duration(milliseconds: 1000), (timer) { print("$count");count++;});
}
