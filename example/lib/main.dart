import 'package:aly_oss/aly_oss.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final _uuid = Uuid();
  final AlyOss _alyOss = AlyOss();
  String id;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ALY OSS Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('INIT'),
                onPressed: () async {
                  var result = await _alyOss.init(InitRequest(
                      _uuid.v4(),
                      'https://wsc-test.happysyrup.com/app/media/get-security-token',
                      'oss-cn-beijing.aliyuncs.com',
                      '11l%UVteM*ct@^Sn',
                      '0000000000000000'));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("INIT"),
                        content: Text(result['instanceId']),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('UPLOAD'),
                onPressed: () async {
                  var image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);

                  _alyOss.upload(UploadRequest(_uuid.v4(),
                      'brand-happysyrup-com', 'ws/a.jpg', image.absolute.path));
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('EXIST'),
                onPressed: () async {
                  var result = await _alyOss.exist(KeyRequest(
                      _uuid.v4(), 'brand-happysyrup-com', 'ws/a.jpg'));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("EXIST"),
                        content: Text(result['exist']),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text('DELETE'),
                onPressed: () async {
                  var result = await _alyOss.delete(KeyRequest(
                      _uuid.v4(), 'brand-happysyrup-com', 'ws/a.jpg'));

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("DELETE"),
                        content: Text('OK'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 180,
              )
            ],
          ),
        ),
      ),
    );
  }
}
