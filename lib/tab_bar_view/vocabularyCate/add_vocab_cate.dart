
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../admin_main_page.dart';
import '../../utils/dropdown_button.dart';
import '../../utils/next_screen.dart';

class AddVocabCate extends StatefulWidget {
  const AddVocabCate({super.key});

  @override
  _AddVocabCateState createState() => _AddVocabCateState();
}

class _AddVocabCateState extends State<AddVocabCate> {
  CollectionReference testDb = FirebaseFirestore.instance.collection('category');

  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vocabulary Category'), backgroundColor: mainColor,),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormForAdd(
                    controller: _contentController,
                    label: "Name"),
                const SizedBox(height: 26.0),
                ElevatedButton(
                  onPressed: _AddVocabCate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.6, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(fontSize: 20),
                  ),
                ),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _AddVocabCate() {
    return testDb.add({
      'cateName': _contentController.text,
    }).then((DocumentReference docRef) {
      print("VocabCate Added with ID: ${docRef.id}");
      // Sau khi thêm, gán ID vào thuộc tính id của question
      testDb.doc(docRef.id).update({'cateId': docRef.id});
      nextScreenReplace(context, const Admin(index: 5));
    }).catchError((error) => print("Failed to add cate: $error"));
  }
}
