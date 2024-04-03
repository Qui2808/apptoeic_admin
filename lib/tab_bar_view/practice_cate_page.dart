import 'package:apptoeic_admin/model/practice.dart';
import 'package:apptoeic_admin/tab_bar_view/practice_cate/practice_cate_detail.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  List<Practice> lstPractice = [];

  @override
  void initState() {
    super.initState();
    readDataFromFireStore();
  }

  Future<void> readDataFromFireStore() async {
    final List<Practice> lst = [];
    await FirebaseFirestore.instance
        .collection('PracticeCate')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        lst.add(Practice.fromJson(doc.data() as Map<String, dynamic>));
      });
    });

    if (lstPractice != lst) {
      setState(() {
        lstPractice = lst;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: lstPractice.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: InkWell(
                  onTap: (){
                    nextScreen(context, PracticeDetail(practice: lstPractice[index]));
                  },
                  child: Card(
                    elevation: 4, // Độ nổi của Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bo góc của Card
                    ),
                    child: ListTile(
                      title: Text(
                        'Practice ${index + 1}: ${lstPractice[index].content!}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Type: ${lstPractice[index].type!}'),
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
                // Add your onPressed function here
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
