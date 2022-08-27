import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ned/services/cloudStorageDelete.dart';
import 'package:ned/services/loader.dart';
import 'package:ned/services/storage.dart';
import 'package:provider/provider.dart';
import 'package:ned/models/user.dart';
import 'package:photo_view/photo_view.dart';



class ImagePickerExample extends StatefulWidget {
  final String value;
  final String uid;
  const ImagePickerExample({Key key, this.value, this.uid}) : super(key: key);

  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File _imageFile;

  bool loader = false;


  final FirebaseStorage _storage = FirebaseStorage(
      storageBucket: 'gs://attem-b235f.appspot.com');


  final CloudStorageService _cloudStorageService = CloudStorageService();
  StorageUploadTask _uploadTask;



  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
  }


  void _clear(){
    setState(() {
      _imageFile = null;
    });
  }

 String timetable = 'https://cdn.lowgif.com/medium/d35d94c490e598e3-loading-gif-transparent-loading-gif.gif';



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this image?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('DELETE', style: TextStyle(color: Colors.red),),
                onPressed: () async {
                  await _cloudStorageService.deleteImage('images/${user.uid}.png',);
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    if(widget.value == null){
      if(_imageFile == null){
        return Scaffold(
          backgroundColor: Colors.white,
            body: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      child: Image.asset('assets/camera.gif',height: 100,),
                      onPressed: () => _pickImage(ImageSource.camera),
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    SizedBox(width: 20.0,),
                    FlatButton(
                      child:Image.asset('assets/gallery.gif',height: 100,),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    )
                  ],
                ),
              ),
            ),
        );
      } else{
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Center(
                    child: Container(
                      child: Loader(),
                        height: 100,
                    ),
                  ),
                ),
                if(_imageFile != null) ...[
                  Image.file(_imageFile),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            mini: true,
                            heroTag: '2',
                            child: Icon(Icons.refresh),
                            backgroundColor: Color(0xFF1a1aff),
                            onPressed: _clear,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Uploader(file: _imageFile, uid: user.uid,),
                        ),
                      ],
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        );
      }
    } else{
      return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 200.0, 0, 0),
                child: Center(
                  child: Container(
                    height: 100,
                      child: Loader(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                      child: Hero(
                          tag: '',
                          child: Image.network(widget.value),
                        ),
                      onTap: () => _showZoomImage(context),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: '1',
          child: Icon(Icons.delete),
          backgroundColor: Color(0xFF1a1aff),
          elevation: 5.0,
          onPressed: (){
            setState(() {
              _showMyDialog();
            });
          },
        ),
      );
    }

  }

  void _showZoomImage(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Scaffold(
          body: Hero(
            tag: '',
            child: PhotoView(
              imageProvider: NetworkImage(widget.value),
              maxScale: 10.0,
            ),
          ),
        )
      )
    );
  }

}

