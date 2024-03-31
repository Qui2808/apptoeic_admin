import 'dart:convert';

class Question {
  String? id;
  String? content;
  String? image;
  String? audio;
  String? opA;
  String? opB;
  String? opC;
  String? opD;
  int? answer;
  int? level;
  int? love;
  int? questionCate;

  Question({this.id, this.content, this.image, this.audio, this.opA,
      this.opB, this.opC, this.opD, this.answer, this.level, this.love,
      this.questionCate});


  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    audio = json['audio'];
    opA = json['opA'];
    opB = json['opB'];
    opC = json['opC'];
    opD = json['opD'];
    answer = json['answer'];
    level = json['level'];
    love = json['love'];
    questionCate = json['questionCate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic> {};
    data['id'] = id;
    data['content'] = content;
    data['image'] = image;
    data['audio'] = audio;
    data['opA'] = opA;
    data['opB'] = opB;
    data['opC'] = opC;
    data['opD'] = opD;
    data['answer'] = answer;
    data['level'] = level;
    data['love'] = love;
    data['questionCate'] = questionCate;
    return data;
  }
}