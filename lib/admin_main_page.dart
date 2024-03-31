import 'package:apptoeic_admin/tab_bar_view/home_page.dart';
import 'package:apptoeic_admin/tab_bar_view/question_list_page.dart';
import 'package:apptoeic_admin/tab_bar_view/tests_page.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic_admin/utils/constColor.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = [
    Tab(text: 'Tổng hợp'),
    Tab(text: 'Đề thi'),
    Tab(text: 'DM đề thi'),
    Tab(text: 'Từ vựng'),
    Tab(text: 'DM từ vựng'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADMIN TOEIC'),
          backgroundColor: mainColor,
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: mainColor,
            tabs: <Widget>[
              Tab(text: "Dashboard"),
              Tab(text: "Questions"),
              Tab(text: "Test level"),
              Tab(text: "Vocabulary"),
              Tab(text: "Vocabulary type"),
            ],
          ),
        ),
        body:  TabBarView(
          children: <Widget>[
            SquareBoxPage(),
            QuestionListPage(),
            TestsPage(),
            Center(
              child: Text("Từ vựng"),
            ),
            Center(
              child: Text("Danh mục từ vựng"),
            ),
          ],
        ),
      ),
    );
  }
}
