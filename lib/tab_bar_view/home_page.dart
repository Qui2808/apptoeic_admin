import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SquareBoxPage extends StatefulWidget {
  const SquareBoxPage({Key? key}) : super(key: key);

  @override
  State<SquareBoxPage> createState() => _SquareBoxPageState();
}

class _SquareBoxPageState extends State<SquareBoxPage> {
  late Stream<QuerySnapshot> questionsStream;
  late Stream<QuerySnapshot> testLevelStream;
  late Stream<QuerySnapshot> practiceCateStream;
  late Stream<QuerySnapshot> vocabStream;
  late Stream<QuerySnapshot> vocabCateStream;

  @override
  void initState() {
    super.initState();
    questionsStream = FirebaseFirestore.instance.collection('questions').snapshots();
    testLevelStream = FirebaseFirestore.instance.collection('testLevel').snapshots();
    practiceCateStream = FirebaseFirestore.instance.collection('PracticeCate').snapshots();
    vocabStream = FirebaseFirestore.instance.collection('vocab').snapshots();
    vocabCateStream = FirebaseFirestore.instance.collection('category').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2, // Số cột trong grid
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: questionsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!.size;
                  return SquareBox(text1: count.toString(), text2: 'Questions', index: 1,);
                } else {
                  return const SquareBox(text1: '0', text2: 'Questions', index: 1);
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: testLevelStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!.size;
                  return SquareBox(text1: count.toString(), text2: 'Test level', index: 2);
                } else {
                  return const SquareBox(text1: '0', text2: 'Test level', index: 2);
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: practiceCateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!.size;
                  return SquareBox(text1: count.toString(), text2: 'Practice', index: 3);
                } else {
                  return const SquareBox(text1: '0', text2: 'Practice', index: 3);
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: vocabStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!.size;
                  return SquareBox(text1: count.toString(), text2: 'Vocabulary', index: 4);
                } else {
                  return const SquareBox(text1: '0', text2: 'Vocabulary', index: 4);
                }
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: vocabCateStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!.size;
                  return SquareBox(text1: count.toString(), text2: 'Vocabulary type', index: 5);
                } else {
                  return const SquareBox(text1: '0', text2: 'Vocabulary type', index: 5);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SquareBox extends StatelessWidget {
  final String text1;
  final String text2;
  final int index;

  const SquareBox({
    required this.text1,
    required this.text2,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Độ nổi của ô vuông
      child: InkWell(
        onTap: (){
          DefaultTabController.of(context)?.animateTo(index);
        },
        child: Container(
          color: Colors.white, // Màu nền của ô vuông
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text1,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8), // Khoảng cách giữa các dòng văn bản
                Text(
                  text2,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
