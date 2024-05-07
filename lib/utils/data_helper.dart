import 'package:apptoeic_admin/model/account.dart';
import 'package:apptoeic_admin/model/practice.dart';
import 'package:apptoeic_admin/model/vocabcategory.dart';
import 'package:apptoeic_admin/model/vocabulary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/testlevel.dart';



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

Future<void> updateQuestionListening(String docId, int answer, String level, String practiceCate, String image, String audio) {
  CollectionReference ques = FirebaseFirestore.instance.collection('questions');

  // Đặt docId là ID của bản ghi mà bạn muốn cập nhật
  return ques.doc(docId).update({
    'answer': answer,
    'level': level,
    'practiceCate': practiceCate,
    'image': image,
    'audio': audio,
  }).then((_) {
    print("Question updated successfully");
  }).catchError((error) {
    print("Failed to update question: $error");
  });
}


Future<void> updateVocabulary(Vocabulary v) {
  CollectionReference vocab = FirebaseFirestore.instance.collection('vocab');

  // Đặt docId là ID của bản ghi mà bạn muốn cập nhật
  return vocab.doc(v.id).update({
    'eng': v.eng,
    'vie': v.vie,
    'spell': v.spell,
    'example': v.example,
  }).then((_) {
    print("Vocabulary updated successfully");
  }).catchError((error) {
    print("Failed to update vocabulary: $error");
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
        levels.add(data['score'] + " - " + data['title']);
      }
    });
  } catch (e) {
    print('Error fetching levels: $e');
    // Xử lý lỗi ở đây nếu cần thiết
  }
  return levels;
}



Future<List<TestLevel>> getTestLevelFromFireStore() async {
  final List<TestLevel> lst = [];
  await FirebaseFirestore.instance
      .collection('testLevel')
      .orderBy('level') // Sắp xếp theo trường 'level' tăng dần
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      lst.add(TestLevel.fromJson(doc.data() as Map<String, dynamic>));
    });
  });

  return lst;
}


Future<List<Practice>> getPracticeFromFireStore() async {
  final List<Practice> lst = [];
  await FirebaseFirestore.instance
      .collection('PracticeCate')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      lst.add(Practice.fromJson(doc.data() as Map<String, dynamic>));
    });
  });

  return lst;
}


Future<List<Vocabulary>> getVocabularyFromFireStore() async {
  final List<Vocabulary> lst = [];
  await FirebaseFirestore.instance
      .collection('vocab')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      lst.add(Vocabulary.fromJson(doc.data() as Map<String, dynamic>));
    });
  });

  return lst;
}

Future<List<VocabCategory>> getVocabCategoryFromFireStore() async {
  final List<VocabCategory> lst = [];
  await FirebaseFirestore.instance
      .collection('category')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      lst.add(VocabCategory.fromJson(doc.data() as Map<String, dynamic>));
    });
  });

  return lst;
}


Future<void> deleteObject(String tableName, String docId) async {
  try {
    await FirebaseFirestore.instance.collection(tableName).doc(docId).delete();
    print('Đã xóa thành công!');
  } catch (e) {
    print('Lỗi khi xóa: $e');
    // Xử lý lỗi ở đây nếu cần thiết
  }
}