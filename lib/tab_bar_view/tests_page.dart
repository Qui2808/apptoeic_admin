import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:flutter/material.dart';

class Test {
  final String title;
  final String summary;

  Test(this.title, this.summary);
}

class TestsPage extends StatelessWidget {
  final List<Test> Tests = [
    Test('Test 1', '300 - 500'),
    Test('Test 2', '500 - 700'),
    Test('Test 3', '700+'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView.builder(
            itemCount: Tests.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                child: Card(
                  elevation: 4, // Độ nổi của Card
                  color: mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Bo góc của Card
                  ),
                  child: ListTile(
                    title: Text(
                      Tests[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Text(Tests[index].summary, style: TextStyle(color: Colors.white),),
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
