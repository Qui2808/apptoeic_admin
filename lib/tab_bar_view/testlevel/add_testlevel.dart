
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../../admin_main_page.dart';
import '../../utils/dropdown_button.dart';
import '../../utils/next_screen.dart';

class AddTestLevel extends StatefulWidget {
  const AddTestLevel({super.key});

  @override
  _AddTestLevelState createState() => _AddTestLevelState();
}

class _AddTestLevelState extends State<AddTestLevel> {
  CollectionReference testDb = FirebaseFirestore.instance.collection('testLevel');

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scoreController.dispose();
    _levelController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Test Level'), backgroundColor: mainColor,),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormForAdd(
                    controller: _titleController,
                    label: "Title"),
                const SizedBox(height: 16.0),
                TextFormForAdd(
                    controller: _descriptionController,
                    label: "Description"),
                const SizedBox(height: 16.0),
                TextFormForAdd(
                    controller: _scoreController,
                    label: "Score"),
                const SizedBox(height: 16.0),
              TextFormField(
                controller: _levelController,
                keyboardType: TextInputType.number, // Kiểu nhập là số
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Chỉ cho phép nhập số
                maxLines: null, // Tự động xuống dòng khi văn bản quá dài
                style: const TextStyle(
                    color:Colors.black
                ),
                decoration: InputDecoration(
                    labelText: "Level",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(28.0),)
                ),
              ),
                const SizedBox(height: 26.0),
                ElevatedButton(
                  onPressed: _addTestLevel,
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

  Future<void> _addTestLevel() {
    return testDb.add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'score': _scoreController.text,
      'level': int.parse(_levelController.text),
    }).then((DocumentReference docRef) {
      print("Test level Added with ID: ${docRef.id}");
      // Sau khi thêm, gán ID vào thuộc tính id của question
      testDb.doc(docRef.id).update({'id': docRef.id});
      nextScreenReplace(context, const Admin(index: 2));
    }).catchError((error) => print("Failed to add test level: $error"));
  }
}
