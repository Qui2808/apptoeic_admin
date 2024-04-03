import 'package:apptoeic_admin/model/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



Future<bool> checkLogin(String username, String pass) async {
  bool check = false;
  Account a;
  await FirebaseFirestore.instance
      .collection('admin')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      a = Account.fromJson(doc.data() as Map<String, dynamic>);
      if(a.username == username && a.password == pass)
        {
          check = true;
          return;
        }
    });
  });
  return check;
}




Future<void> updateQuestion(String docId, String content, String opA, String opB, String opC, String opD, int answer, String level, String practiceCate) {
  CollectionReference ques = FirebaseFirestore.instance.collection('questions');

  // Đặt docId là ID của bản ghi mà bạn muốn cập nhật
  return ques.doc(docId).update({
    'content': content,
    'opA': opA,
    'opB': opB,
    'opC': opC,
    'opD': opD,
    'answer': answer,
    'level': level,
    'practiceCate': practiceCate,
  }).then((_) {
    print("Question updated successfully");
  }).catchError((error) {
    print("Failed to update question: $error");
  });
}



Future<List<String>> getScoreFromTestLevel() async {
  List<String> levels = [];
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('testLevel')
        .orderBy('level') // Sắp xếp theo trường 'level' tăng dần
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('score')) {
        levels.add(data['score']);
      }
    });
  } catch (e) {
    print('Error fetching levels: $e');
    // Xử lý lỗi ở đây nếu cần thiết
  }
  return levels;
}