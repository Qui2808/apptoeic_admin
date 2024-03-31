import 'package:flutter/material.dart';

class SquareBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2, // Số cột trong grid
          children: [
            SquareBox(
              text1: '12',
              text2: 'Questions',
              index: 1,
            ),
            SquareBox(
              text1: '3',
              text2: 'Test level',
              index: 2,
            ),
            SquareBox(
              text1: '40',
              text2: 'Vocabulary',
              index: 4,
            ),
            SquareBox(
              text1: '5',
              text2: 'Vocabulary type',
              index: 5,
            )
          ]
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
    Key? key,
    required this.text1,
    required this.text2,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DefaultTabController.of(context)?.animateTo(index);
      },
      child: Card(
        elevation: 4, // Độ nổi của ô vuông
        child: Container(
          color: Colors.white, // Màu nền của ô vuông
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text1,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8), // Khoảng cách giữa các dòng văn bản
                Text(
                  text2,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

