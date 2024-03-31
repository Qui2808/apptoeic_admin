import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:flutter/material.dart';

import '../../model/question.dart';
import '../../utils/textFormField.dart';

class QuestionDetail extends StatefulWidget {
  final Question question;

  const QuestionDetail({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionDetailState createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  late TextEditingController _contentController;
  late TextEditingController _opAController;
  late TextEditingController _opBController;
  late TextEditingController _opCController;
  late TextEditingController _opDController;
  late TextEditingController _answerController;
  late TextEditingController _levelController;
  late TextEditingController _cateController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.question.content);
    _opAController = TextEditingController(text: widget.question.opA);
    _opBController = TextEditingController(text: widget.question.opB);
    _opCController = TextEditingController(text: widget.question.opC);
    _opDController = TextEditingController(text: widget.question.opD);
    _answerController = TextEditingController(text: widget.question.answer.toString());
    _levelController = TextEditingController(text: widget.question.level.toString());
    _cateController = TextEditingController(text: widget.question.questionCate.toString());
  }

  @override
  void dispose() {
    _contentController.dispose();
    _opAController.dispose();
    _opBController.dispose();
    _opCController.dispose();
    _opDController.dispose();
    _answerController.dispose();
    _levelController.dispose();
    _cateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Detail'),
        backgroundColor: mainColor,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       setState(() {
        //         _isEditing = !_isEditing;
        //       });
        //     },
        //     icon: Icon(_isEditing ? Icons.save : Icons.edit),
        //   ),
        // ],
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
                  TextFormDetail(
                      controller: _contentController,
                      isEditing: _isEditing,
                      label: "Content"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _opAController,
                      isEditing: _isEditing,
                      label: "Option A"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _opBController,
                      isEditing: _isEditing,
                      label: "Option B"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _opCController,
                      isEditing: _isEditing,
                      label: "Option C"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _opDController,
                      isEditing: _isEditing,
                      label: "Option D"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _answerController,
                      isEditing: _isEditing,
                      label: "Answer"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _levelController,
                      isEditing: _isEditing,
                      label: "Level"),
                  SizedBox(height: 16.0),
                  TextFormDetail(
                      controller: _cateController,
                      isEditing: _isEditing,
                      label: "Category"),
                  SizedBox(height: 16.0),
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
                      onPressed: _EditButtonOnClick,
                      child: Text(_isEditing ? 'Save' : 'Edit'),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.12),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: _DeleteButtonOnClick,
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

  void _EditButtonOnClick() {
    if (!_isEditing) {
      setState(() {
        _isEditing = !_isEditing;
        print(MediaQuery.of(context).size.width);
      });
    } else {
      setState(() {
        _isEditing = !_isEditing;
      });
      print("Đã lưu");
    }
  }

  void _DeleteButtonOnClick() {
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
}
