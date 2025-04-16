import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hands_test/model/interpreter.dart';

class FirestoreInterpreter {
  final CollectionReference _interpreterCollectionRef = FirebaseFirestore.instance.collection('Interpreter');

  Future<void> adInterpretertToFirestore(Interpreter interpreter) async {
    return await _interpreterCollectionRef.doc(interpreter.id).set(interpreter.toJson());
  }

  checkInterpreter(String uid) async {
    var data = await _interpreterCollectionRef.doc(uid).get();
    return data.exists;
  }

  Future<DocumentSnapshot> getCurrentInterpreter(String uid) async {
    return await _interpreterCollectionRef.doc(uid).get();
  }

  Future<void> updateInterpreterInfo({
    required String key,
    required dynamic value,
    required String id,
  }) async {
    return await _interpreterCollectionRef.doc(id).update({
      key: value,
    });
  }
}