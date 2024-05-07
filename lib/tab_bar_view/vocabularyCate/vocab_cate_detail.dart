import 'package:apptoeic_admin/model/practice.dart';
import 'package:apptoeic_admin/model/vocabcategory.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/dropdown_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/text_form_field.dart';

class VocabCateDetail extends StatefulWidget {
  final VocabCategory category;

  const VocabCateDetail({Key? key, required this.category}) : super(key: key);

  @override
  _VocabCateDetailState createState() => _VocabCateDetailState();
}

class _VocabCateDetailState extends State<VocabCateDetail> {
  CollectionReference practiceDb = FirebaseFirestore.instance.collection('category');

  late TextEditingController _cateNameController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _cateNameController = TextEditingController(text: widget.category.cateName);

  }

  @override
  void dispose() {
    _cateNameController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VocabCategory Detail'),
        backgroundColor: mainColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormForEdit(
                      controller: _cateNameController,
                      isEditing: _isEditing,
                      label: "Name"),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(mainColor)),
                    onPressed: _editButtonOnClick,
                    child: Text(_isEditing ? 'Save' : 'Edit'),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.12),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade900)),
                    onPressed: _deleteButtonOnClick,
                    child: Text('Delete'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _editButtonOnClick() {
    if (!_isEditing) {
      setState(() {
        _isEditing = !_isEditing;
      });
    } else {
      setState(() {
        _isEditing = !_isEditing;
      });
      updateCategory(widget.category.cateId!);
      print("Đã lưu");
    }
  }

  void _deleteButtonOnClick() {
    // deleteObject("category", widget.category.cateId!);
    // const snackBar = SnackBar(content: Text("Delete successful"));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // nextScreenReplace(context, Admin(index: 5));
  }

  Future<void> updateCategory(String docId) {
    CollectionReference testDb = FirebaseFirestore.instance.collection('category');

    // Đặt docId là ID của bản ghi mà bạn muốn cập nhật
    return testDb.doc(docId).update({
      'cateName': _cateNameController.text,
    }).then((_) {
      print("Question updated successfully");
    }).catchError((error) {
      print("Failed to update question: $error");
    });
  }
}
