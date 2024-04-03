import 'package:apptoeic_admin/model/practice.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/dropdown_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/text_form_field.dart';

class PracticeDetail extends StatefulWidget {
  final Practice practice;

  const PracticeDetail({Key? key, required this.practice}) : super(key: key);

  @override
  _PracticeDetailState createState() => _PracticeDetailState();
}

class _PracticeDetailState extends State<PracticeDetail> {
  CollectionReference practiceDb = FirebaseFirestore.instance.collection('PracticeCate');

  late TextEditingController _contentController;
  late TextEditingController _typeController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.practice.content);
    _typeController = TextEditingController(text: widget.practice.type);

  }

  @override
  void dispose() {
    _contentController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  List<String> lstType = [
    'Reading',
    'Listening',
  ];
  String selectedType = 'Reading';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Detail'),
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
                      controller: _contentController,
                      isEditing: _isEditing,
                      label: "Content"),
                  const SizedBox(height: 16.0),
                  DropdownButtonForEdit(
                      lstObjects: lstType,
                      selectedObject: selectedType,
                      labelText: 'Type',
                      isEditing: _isEditing),
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

}
