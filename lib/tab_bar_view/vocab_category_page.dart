import 'package:apptoeic_admin/model/vocabcategory.dart';
import 'package:apptoeic_admin/tab_bar_view/vocabularyCate/add_vocab_cate.dart';
import 'package:apptoeic_admin/tab_bar_view/vocabularyCate/vocab_cate_detail.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class VocabCategoryPage extends StatefulWidget {
  const VocabCategoryPage({super.key});

  @override
  State<VocabCategoryPage> createState() => _VocabCategoryPageState();
}

class _VocabCategoryPageState extends State<VocabCategoryPage> {
  List<VocabCategory> lstCate = [];

  @override
  void initState() {
    super.initState();
    readDataFromFireStore();
  }

  Future<void> readDataFromFireStore() async {
    final List<VocabCategory> lst = [];
    await FirebaseFirestore.instance
        .collection('category')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        lst.add(VocabCategory.fromJson(doc.data() as Map<String, dynamic>));
      });
    });

    if (lstCate != lst) {
      setState(() {
        lstCate = lst;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: lstCate.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: InkWell(
                  onTap: (){
                    nextScreen(context, VocabCateDetail(category: lstCate[index]));
                  },
                  child: Card(
                    elevation: 4, // Độ nổi của Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bo góc của Card
                    ),
                    child: ListTile(
                      title: Text(
                        'Category ${index + 1}: ${lstCate[index].cateName!}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                nextScreen(context, AddVocabCate());
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
