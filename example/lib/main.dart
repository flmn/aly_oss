import 'package:aly_oss/aly_oss.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AlyOss alyOss = AlyOss();

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
                  alyOss.init(InitRequest(
                      UuidHelper.gen(),
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

                  alyOss.upload(UploadRequest(UuidHelper.gen(),
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
