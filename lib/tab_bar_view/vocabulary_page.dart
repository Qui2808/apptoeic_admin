import 'package:apptoeic_admin/model/vocabulary.dart';
import 'package:apptoeic_admin/tab_bar_view/vocabulary/add_vocabulary.dart';
import 'package:apptoeic_admin/tab_bar_view/vocabulary/vocabulary_detail.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  List<Vocabulary> lstVocab = [];

  @override
  void initState() {
    super.initState();
    readDataFromFireStore();
  }

  Future<void> readDataFromFireStore() async {
    final List<Vocabulary> lst = [];
    await FirebaseFirestore.instance
        .collection('vocab')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        lst.add(Vocabulary.fromJson(doc.data() as Map<String, dynamic>));
      });
    });

    if (lstVocab != lst) {
      setState(() {
        lstVocab = lst;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: lstVocab.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: InkWell(
                  onTap: (){
                    nextScreen(context, VocabularyDetail(vocabulary: lstVocab[index]));
                  },
                  child: Card(
                    elevation: 4, // Độ nổi của Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Bo góc của Card
                    ),
                    child: ListTile(
                      title: Text(
                        '${index + 1}- ${lstVocab[index].eng!}: ${lstVocab[index].vie!}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(' ${lstVocab[index].spell!}'),
                    ),
                  ),
                ),
              );
            },
            padding: const EdgeInsets.only(bottom: 80.0),
          ),
          Positioned(
            bottom: 24.0,
            right: 28.0,
            child: FloatingActionButton(
              backgroundColor: mainColor,
              onPressed: () {
                nextScreen(context, AddVocabulary());
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
