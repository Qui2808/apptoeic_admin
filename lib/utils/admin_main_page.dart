
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../HomePage.dart';
import '../utils/constText.dart';

class StudentMainPage extends StatefulWidget {
  const StudentMainPage({super.key});

  @override
  State<StudentMainPage> createState() => _StudentMainPageState();
}

class _StudentMainPageState extends State<StudentMainPage> {
  int _selectedIndex = 0;

  List<String> _labels = ['HOME', 'TEST', 'VOCABULARY', 'SETTING'];
  late String lableName;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const HomePage(),
    const HomePage(),
    const HomePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      lableName = _labels[index];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lableName = _labels[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: TextAppbar(lableName),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: const Icon(Icons.home), label: _labels[0]),
            BottomNavigationBarItem(
                icon: const Icon(Icons.schedule_outlined), label: _labels[1]),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search), label: _labels[2]),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings), label: _labels[3])
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: mainColor,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
