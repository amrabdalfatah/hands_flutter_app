import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hands_test/model/student.dart';

class FirestoreStudent {
  final CollectionReference _studentCollectionRef = FirebaseFirestore.instance.collection('Students');

  Future<void> addStudentToFirestore(Student student) async {
    return await _studentCollectionRef.doc(student.id).set(student.toJson());
  }

  checkStudent(String uid) async {
    var data = await _studentCollectionRef.doc(uid).get();
    return data.exists;
  }

  Future<DocumentSnapshot> getCurrentStudent(String uid) async {
    return await _studentCollectionRef.doc(uid).get();
  }

  Future<void> updateStudentInfo({
    required String key,
    required dynamic value,
    required String id,
  }) async {
    return await _studentCollectionRef.doc(id).update({
      key: value,
    });
  }
}