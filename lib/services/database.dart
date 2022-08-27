import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ned/models/leaves.dart';
import 'package:ned/models/user.dart';

class DatabaseService {

  final String name;
  final String course;
  final String uid;
  final String email;
  final String photo;
  final String postCounter;
  final String datePosted;
  DatabaseService({ this.photo, this.uid,this.course, this.email, this.name, this.datePosted, this.postCounter});

  //collection reference
  Firestore db = Firestore.instance;
  final CollectionReference attemRefernce = Firestore.instance.collection('Attem Courses');
  final CollectionReference userReference = Firestore.instance.collection('Attem Users');
  final CollectionReference tuitionReference = Firestore.instance.collection('Attem Tuitions');
  final CollectionReference parentReference = Firestore.instance.collection('Attem Parent Posts');
  final CollectionReference booksReference = Firestore.instance.collection('Books');


  //make sperate database for password

  Future updateCourseData(String courseName, String courseCode, int leaves, String courseType) async {
    return await attemRefernce.document(uid).collection(email).document(course).setData({
      'Email' : email,
      'Course Type' : courseType,
      'Course Name' : courseName,
      'Course Code' : courseCode,
      'leaves' : leaves,
    });
  }

  Future updateBooksData(String bookName, String authorName, String cover, String pdf) async {
    return await booksReference.document(bookName+'-'+authorName).setData({
      'Book Name' : bookName,
      'Author Name' : authorName,
      'Cover' : cover,
      'PDF' : pdf,
    });
  }

  //del user doucment
  Future delDocument() async{
    return await userReference.document(email).delete();
  }
  Future delTutorDocument(String counter) async{
    return await tuitionReference.document(counter).delete();
  }


  Future delCourseDocument(String course) async{
    return await attemRefernce.document(uid).collection(email).document(course).delete();
  }

  Future updateUserBioData(String name, bool maleGender, String portalID, String enroll, String criteria, String sem, String dept, String uni,) async {
    return await userReference.document(email).setData({
      'Photo' : photo,
      'User ID' : uid,
      'Name' : name,
      'Male Gender' : maleGender,
      'Email' : email,
      'Portal ID' : portalID,
      'Enrollment No.' : enroll,
      'Criteria' : criteria,
      'Semester' : sem,
      'Dept' : dept,
      'Uni' : uni,
    });
  }

  Future updateTutorsData(String subjects, String classes, String location, String requirement, String contact, String gender) async {
    return await tuitionReference.document(postCounter).setData({
      'Subjects' : subjects,
      'Classes' : classes,
      'Location' : location,
      'Requirement' : requirement,
      'Contact' : contact,
      'Gender' : gender,
      'Post Counter' : postCounter,
      'Date Posted' : datePosted,
    });
  }

  Future updateParentPostData(String subjects, String classes, String location, String requirement, String contact, String gender) async {
    return await parentReference.document('$datePosted - $email').setData({
      'Parent Name' : name,
      'Subjects' : subjects,
      'Classes' : classes,
      'Location' : location,
      'Requirement' : requirement,
      'Contact' : contact,
      'Gender' : gender,
      'Post Counter' : postCounter,
      'Date Posted' : datePosted,
    });
  }



  //course list from snapshot
  List<Course> _courseListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Course(
        courseCode: doc.data['Course Code'] ?? 'Course Code',
        courseName: doc.data['Course Name'] ?? 'Course Name',
        leaves: doc.data['leaves'] ?? 0,
        courseType: doc.data['Course Type'] ?? 'Course Type',
        email: doc.data['Email'] ?? 'Email',
      );
    }).toList();
  }

  List<CourseNames> _courseNamesFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return CourseNames(
        courseNames: doc.data['Course Name'] ?? 'Course Name'
      );
    }).toList();
  }

  //course data from snapshot
  CourseData _courseDataFromSnapshot(DocumentSnapshot snapshot){
    return CourseData(
      leaves: snapshot.data['leaves'] ?? 'Leaves',
      code: snapshot.data['Course Code'] ?? 'Course code',
      courseName: snapshot.data['Course Name'] ?? 'Course Name',
      type: snapshot.data['Course Type'] ?? 'Course Type',

    );
  }

  List<UserBioData> _userDataForAdmin(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserBioData(
        photo: doc.data['Photo'] ?? '',
      uid: doc.data['User ID'] ?? 'User ID',
      name: doc.data['Name'] ?? 'User Name',
      maleGender: doc.data['Male Gender'] ?? true,
      email: doc.data['Email'] ?? 'Email',
      portalID: doc.data['Portal ID'] ?? 'Portal ID',
      enroll: doc.data['Enrollment No.'] ?? 'Enrollment No.',
      cri: doc.data['Criteria'] ?? 'Criteria',
      sem: doc.data['Semester'] ?? 'Semester',
      dept: doc.data['Dept'] ?? 'Department',
      uni: doc.data['Uni'] ?? 'University',
    );
    }).toList();
  }

  List<TuitionData> _tutorData(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return TuitionData(
        postCounter: doc.data['Post Counter'] ?? '',
        datePosted: doc.data['Date Posted'] ?? '',
        subjects: doc.data['Subjects'] ?? '',
        requirement: doc.data['Requirement'] ?? '',
        location: doc.data['Location'] ?? '',
        gender: doc.data['Gender'] ?? '',
        contact: doc.data['Contact'] ?? '',
        classes: doc.data['Classes'] ?? '',
      );
    }).toList();
  }
  List<BooksData> _booksListFromScreenshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return BooksData(
        title: doc.data['Book Name'] ?? '',
        author: doc.data['Author Name'] ?? '',
        cover: doc.data['Cover'] ?? '',
        pdf: doc.data['PDF'] ?? ''
      );
    }).toList();
  }

  UserBioData _userBioDataFromSnapshot(DocumentSnapshot snapshot){
    return UserBioData(
      photo: snapshot.data['Photo'] ?? '',
      uid: snapshot.data['User ID'] ?? 'User ID',
      name: snapshot.data['Name'] ?? 'User Name',
      maleGender: snapshot.data['Male Gender'] ?? true,
      email: snapshot.data['Email'] ?? 'Email',
      portalID: snapshot.data['Portal ID'] ?? 'Portal ID',
      enroll: snapshot.data['Enrollment No.'] ?? 'Enrollment No.',
      cri: snapshot.data['Criteria'] ?? 'Criteria',
      sem: snapshot.data['Semester'] ?? 'Semester',
      dept: snapshot.data['Dept'] ?? 'Department',
      uni: snapshot.data['Uni'] ?? 'University',
    );
  }



  //AdminData
  Stream<List<UserBioData>> get userDataForAdmin {
    return userReference.snapshots()
        .map(_userDataForAdmin);
  }
  //Tutor Data
  Stream<List<TuitionData>> get tutorData {
    return tuitionReference.snapshots()
        .map(_tutorData);
  }
    //get Courses Snapshot
    Stream<List<Course>> get courses {
    return attemRefernce.document(uid).collection(email).snapshots()
      .map(_courseListFromSnapshot);
    }

    //get course detail for update
    Stream<CourseData> get courseData{
    return attemRefernce.document(uid).collection(email).document(course).snapshots()
        .map(_courseDataFromSnapshot);
    }

    Stream<UserBioData> get userData{
      return userReference.document(email).snapshots()
        .map(_userBioDataFromSnapshot);
    }


  Stream<List<CourseNames>> get courseNames {
    return attemRefernce.document(uid).collection(email).snapshots()
        .map(_courseNamesFromSnapshot);
    }

  Stream<List<BooksData>> get booksData {
    return booksReference.snapshots()
        .map(_booksListFromScreenshot);
  }

}