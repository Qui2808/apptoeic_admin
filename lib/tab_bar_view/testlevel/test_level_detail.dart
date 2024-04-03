import 'package:apptoeic_admin/model/testlevel.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/text_form_field.dart';

class TestLevelDetail extends StatefulWidget {
  final TestLevel testLevel;

  const TestLevelDetail({Key? key, required this.testLevel}) : super(key: key);

  @override
  _TestLevelDetailState createState() => _TestLevelDetailState();
}

class _TestLevelDetailState extends State<TestLevelDetail> {
  CollectionReference testDb = FirebaseFirestore.instance.collection('testLevel');

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _scoreController;
  late TextEditingController _levelController;


  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.testLevel.title);
    _descriptionController = TextEditingController(text: widget.testLevel.description);
    _scoreController = TextEditingController(text: widget.testLevel.score);
    _levelController = TextEditingController(text: widget.testLevel.level.toString());
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
      appBar: AppBar(
        title: const Text('Test Level Detail'),
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
                      controller: _titleController,
                      isEditing: _isEditing,
                      label: "Title"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _descriptionController,
                      isEditing: _isEditing,
                      label: "Description"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _scoreController,
                      isEditing: _isEditing,
                      label: "Score"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _levelController,
                      isEditing: _isEditing,
                      label: "Level"),
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
      updateTestLevel(widget.testLevel.id!);
      print("Đã lưu");
    }
  }

  void _deleteButtonOnClick() {
    if (!_isEditing) {
      setState(() {
        _isEditing = !_isEditing;
      });
    } else {
      setState(() {
        _isEditing = !_isEditing;
      });
      print("Đã xóa");
    }
  }


  Future<void> updateTestLevel(String docId) {
    // Đặt docId là ID của bản ghi mà bạn muốn cập nhật
    return testDb.doc(docId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'score': _scoreController.text,
      'level': _levelController.text,
    }).then((_) {
      print("Question updated successfully");
    }).catchError((error) {
      print("Failed to update question: $error");
    });
  }

}
