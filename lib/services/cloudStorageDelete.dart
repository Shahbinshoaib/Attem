
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService{


  StorageReference reference = FirebaseStorage.instance.ref();


  Future deleteImage(String image) async{
    final StorageReference reference = FirebaseStorage.instance.ref().child(image);
    try{
      await reference.delete();
    } catch(e){
      return e.toString();
    }
  }

  Future downloadImage(String uid) async{
    try{
      String downloadAddress = await reference.child('images/${uid}.png').getDownloadURL();
      return downloadAddress;
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  Future downloadPDF(String uid) async{
    try{
      String downloadAddress = await reference.child('pdfs/${uid}.pdf').getDownloadURL();
      return downloadAddress;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}