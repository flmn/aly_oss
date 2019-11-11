import 'package:aly_oss/aly_oss.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AlyOss alyOss1 = AlyOss();
  AlyOss alyOss2 = AlyOss();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ALY OSS Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('INIT'),
                onPressed: () {
                  alyOss1.init();
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('UPLOAD'),
                onPressed: () {
                  alyOss1.upload(
                      'brand-happysyrup-com', 'ws/a.jpg', 'assets/tower.jpg');
                },
              ),
              Image.asset(
                'assets/tower.jpg',
                height: 480,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
