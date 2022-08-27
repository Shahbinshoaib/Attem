import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget{
  final file;
  final String uid;


  Uploader({Key key, this.file, this.uid}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://attem-b235f.appspot.com');


  int _state = 1;

  Icon icon = Icon(Icons.save);

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${widget.uid}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }




  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot){
          var event = snapshot?.data?.snapshot;

          double progressPercent = event != null ? event.bytesTransferred / event.totalByteCount : 0;

          if(_uploadTask.isComplete)
            {
              return FloatingActionButton(
                child: Icon(Icons.check),
                onPressed: (){},
                backgroundColor: Color(0xFF1a1aff),
              );
            }
          else{
            return FloatingActionButton(
              child: setUpButtonChild(),
              backgroundColor: Color(0xFF1a1aff),
              onPressed: () {
                setState(() {
                  if (_state == 0) {
                    animateButton();
                  }
                });
              },
            );
          }

        },
      );

    } else {
      return Column(
        children: <Widget>[
          FloatingActionButton(
            mini: false,
            backgroundColor: Color(0xFF1a1aff),
            child: icon,
            onPressed: _startUpload,
          ),
        ],
      );
    }
  }
  Widget setUpButtonChild() {
     if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 2;
      });
    });
  }
}