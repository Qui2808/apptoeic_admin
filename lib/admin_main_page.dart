import 'package:apptoeic_admin/tab_bar_view/home_page.dart';
import 'package:apptoeic_admin/tab_bar_view/practice_cate_page.dart';
import 'package:apptoeic_admin/tab_bar_view/question_list_page.dart';
import 'package:apptoeic_admin/tab_bar_view/testlevel_page.dart';
import 'package:apptoeic_admin/tab_bar_view/vocab_category_page.dart';
import 'package:apptoeic_admin/tab_bar_view/vocabulary_page.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic_admin/utils/constColor.dart';

class Admin extends StatefulWidget {
  final int index;
  const Admin({Key? key, required this.index}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with SingleTickerProviderStateMixin {
  late TabController _tabController;


  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
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
      initialIndex: widget.index,
      length: 6,
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
              Tab(text: "Practice cate"),
              Tab(text: "Vocabulary"),
              Tab(text: "Vocabulary type"),
            ],
          ),
        ),
        body:  TabBarView(
          children: <Widget>[
            SquareBoxPage(),
            QuestionListPage(),
            TestLevelPage(),
            PracticePage(),
            VocabularyPage(),
            VocabCategoryPage(),
          ],
        ),
      ),
    );
  }
}
