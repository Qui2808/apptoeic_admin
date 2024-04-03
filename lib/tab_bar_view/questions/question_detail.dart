import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/dropdown_button.dart';
import 'package:flutter/material.dart';

import '../../model/question.dart';
import '../../utils/data_helper.dart';
import '../../utils/text_form_field.dart';

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

  List<String> answer = ['1', '2', '3', '4'];
  String selectedAnswer = '1';

  List<String> levels = ['300 - 500', '500 - 700', '700 - 900'];
  List<String> practices = ['Complete The Sentences', 'Text Completion', 'Reading Comprehension','Photographs', 'Question Response', 'TConversations'];

  String selectedLevel = '300 - 500';
  String selectedPractice = 'Complete The Sentences';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.question.content);
    _opAController = TextEditingController(text: widget.question.opA);
    _opBController = TextEditingController(text: widget.question.opB);
    _opCController = TextEditingController(text: widget.question.opC);
    _opDController = TextEditingController(text: widget.question.opD);
    //_answerController = TextEditingController(text: widget.question.answer.toString());
    // selectedLevel = widget.question.level.toString();
    // selectedPractice =  widget.question.questionCate.toString();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _opAController.dispose();
    _opBController.dispose();
    _opCController.dispose();
    _opDController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Detail'),
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
                  TextFormForEdit(
                      controller: _opAController,
                      isEditing: _isEditing,
                      label: "Option A"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _opBController,
                      isEditing: _isEditing,
                      label: "Option B"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _opCController,
                      isEditing: _isEditing,
                      label: "Option C"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _opDController,
                      isEditing: _isEditing,
                      label: "Option D"),
                  const SizedBox(height: 16.0),
                  DropdownButtonForEdit(
                      lstObjects: answer,
                      selectedObject: selectedAnswer,
                      labelText: 'Answer',
                      isEditing: _isEditing
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonForEdit(
                      lstObjects: levels,
                      selectedObject: selectedLevel,
                      labelText: 'Level',
                      isEditing: _isEditing
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonForEdit(
                      lstObjects: practices,
                      selectedObject: selectedPractice,
                      labelText: 'Practice',
                      isEditing: _isEditing
                  ),
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
                      onPressed: _EditButtonOnClick,
                      child: Text(_isEditing ? 'Save' : 'Edit'),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.12),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red.shade900)),
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
      updateQuestion(widget.question.id!, _contentController.text, _opAController.text, _opBController.text, _opCController.text,
          _opDController.text, int.parse(selectedAnswer), "Z6Ab07u7bWL9WJlRg9El", "OQ2oZSDQDIkHbNOnHrWT");
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
      print("Đã xóa");
    }
  }

}
