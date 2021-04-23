import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: SensorDemo(),
          ),
        ),
      ),
    );
  }

}
class SensorDemo extends StatefulWidget {
  @override
  _SensorDemoState createState() => _SensorDemoState();
}

class _SensorDemoState extends State<SensorDemo> {


  List<StreamSubscription<dynamic>> _streamSubscriptions =
  <StreamSubscription<dynamic>>[];
  double x;
  double y;
  double z;

  double count;

  double result = 35.0;
  @override
  initState(){
    super.initState();
    ///不受重力影响的加速器
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
          setState(() {
            x=event.x.abs();
            y=event.y.abs();
            z=event.z.abs();
            count = (x+y+z);
            if(count>result){
              list.add(returnResult());
            }
          });
    }));
  }

  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
  Widget returnResult(){
    return Text("老人疑似摔倒");
  }

  List<Widget> list =List();
  Widget returnAcceleration(){
    return Text("X轴加速度:$x,\nY轴加速度$y,\nZ轴加速度$z"
        "\n加速度为:${count.toStringAsFixed(2)}");
  }
  @override
  Widget build(BuildContext context) {
    list.add(returnAcceleration());
    return Container(
      child: Column(
        children: list,
      ),
    );
  }
}

