import 'package:flutter/material.dart';

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
        body: ListViewDemo(),
      ),
    );
  }
}

class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  @override
  Widget build(BuildContext context) {
    /*return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 500,
                          width: 500,
                          child: Flexible(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      ElevatedButton(onPressed: null, child: Text("aaa")),
                                    ],
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[600],
                                    child: const Center(child: Text('Entry A')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[500],
                                    child: const Center(child: Text('Entry B')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[100],
                                    child: const Center(child: Text('Entry C')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[600],
                                    child: const Center(child: Text('Entry A')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[500],
                                    child: const Center(child: Text('Entry B')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[100],
                                    child: const Center(child: Text('Entry C')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[600],
                                    child: const Center(child: Text('Entry A')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[500],
                                    child: const Center(child: Text('Entry B')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[100],
                                    child: const Center(child: Text('Entry C')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[600],
                                    child: const Center(child: Text('Entry A')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[500],
                                    child: const Center(child: Text('Entry B')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[100],
                                    child: const Center(child: Text('Entry C')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[600],
                                    child: const Center(child: Text('Entry A')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[500],
                                    child: const Center(child: Text('Entry B')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[100],
                                    child: const Center(child: Text('Entry C')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[600],
                                    child: const Center(child: Text('Entry A')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[500],
                                    child: const Center(child: Text('Entry B')),
                                  ),
                                  Container(
                                    height: 50,
                                    color: Colors.amber[100],
                                    child: const Center(child: Text('Entry C')),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ),
                        Container(
                          child:           ElevatedButton(onPressed: null, child: Text("按钮1")),

                        )
                        //ElevatedButton(onPressed: null, child: Text("aa")),
                      ],
                    ))
              ],
            ),
          )
        ],
    );*/
    return Column(
      children: <Widget>[
        Container(
          child: ElevatedButton(onPressed: null,
            child: Text("我是按钮"),),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //头像---添加信息部分
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry c')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry a')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry c')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry a')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry c')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry a')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry c')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry a')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry c')),
                ),Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry a')),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
