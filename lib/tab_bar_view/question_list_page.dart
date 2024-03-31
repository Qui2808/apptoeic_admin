import 'package:apptoeic_admin/model/question.dart';
import 'package:apptoeic_admin/tab_bar_view/questions/add_question.dart';
import 'package:apptoeic_admin/tab_bar_view/questions/question_detail.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QuestionListPage extends StatefulWidget {
  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    ReadDataFromFireStore();
  }

  Future<void> ReadDataFromFireStore() async{
    final List<Question> lst = [];
    await FirebaseFirestore.instance
        .collection('questions')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        lst.add(Question.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
    if(questions != lst){
      setState(() {
        questions = lst;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: questions.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: InkWell(
                  onTap: (){
                    nextScreen(context, QuestionDetail(question: questions[index]));
                  },
                  child: Card(
                    elevation: 4, // Độ nổi của Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bo góc của Card
                    ),
                    child: ListTile(
                      title: Text(
                        'Question ' + (index + 1).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(questions[index].content!),
                    ),
                  ),
                ),
              );
            },
            padding: EdgeInsets.only(bottom: 80.0),
          ),
          Positioned(
            bottom: 24.0,
            right: 28.0,
            child: FloatingActionButton(
              backgroundColor: mainColor,
              onPressed: () {
                addQuestion();
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
