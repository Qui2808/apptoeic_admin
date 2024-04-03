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
  String? level;
  String? practiceCate;

  Question({this.id, this.content, this.image, this.audio, this.opA,
      this.opB, this.opC, this.opD, this.answer, this.level,
      this.practiceCate});


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
    practiceCate = json['practiceCate'];
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
    data['practiceCate'] = practiceCate;
    return data;
  }
}