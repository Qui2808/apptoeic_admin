import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference ques = FirebaseFirestore.instance.collection('questions');

Future<void> addQuestion() {
  // Call the user's CollectionReference to add a new user
  return ques.add({
    'content': "I ____ a car next year",
    'image': null,
    'audio': null,
    'opA': "buy",
    'opB': "am buying",
    'opC': "going to buy",
    'opD': "bought",
    'answer': 2,
    'level': 1,
    'love': null,
    'questionCate': 2,
    // 42
  }).then((DocumentReference docRef) {
    print("Question Added with ID: ${docRef.id}");
    // Sau khi thêm, gán ID vào thuộc tính id của question
    ques.doc(docRef.id).update({'id': docRef.id});
  }).catchError((error) => print("Failed to add question: $error"));
}
