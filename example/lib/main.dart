import 'package:aly_oss/aly_oss.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _uuid = Uuid();
  final AlyOss _alyOss = AlyOss();

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
                  _alyOss.init(InitRequest(
                      _uuid.v4(),
                      'https://wsc-test.happysyrup.com/app/media/get-security-token',
                      'oss-cn-beijing.aliyuncs.com',
                      '11l%UVteM*ct@^Sn',
                      '0000000000000000'));
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
            ],
          ),
        ),
      ),
    );
  }
}
