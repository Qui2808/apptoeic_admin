import 'package:apptoeic_admin/model/testlevel.dart';
import 'package:apptoeic_admin/tab_bar_view/testlevel/add_testlevel.dart';
import 'package:apptoeic_admin/tab_bar_view/testlevel/test_level_detail.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TestLevelPage extends StatefulWidget {
  @override
  State<TestLevelPage> createState() => _TestLevelPageState();
}

class _TestLevelPageState extends State<TestLevelPage> {
  List<TestLevel> lstTestLevel = [];

  @override
  void initState() {
    super.initState();
    readDataFromFireStore();
  }

  Future<void> readDataFromFireStore() async {
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

    if (lstTestLevel != lst) {
      setState(() {
        lstTestLevel = lst;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: lstTestLevel.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: InkWell(
                  onTap: (){
                    nextScreen(context, TestLevelDetail(testLevel: lstTestLevel[index]));
                  },
                  child: Card(
                    elevation: 4, // Độ nổi của Card
                    color: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bo góc của Card
                    ),
                    child: ListTile(
                      title: Text(
                        lstTestLevel[index].title!,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(lstTestLevel[index].score!, style: TextStyle(color: Colors.white),),
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
              backgroundColor: Colors.grey,
              onPressed: () {
                nextScreen(context, AddTestLevel());
              },
              child: const Icon(Icons.add, color: mainColor,),
            ),
          ),
        ],
      ),
    );
  }
}
