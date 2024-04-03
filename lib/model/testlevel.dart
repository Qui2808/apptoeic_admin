
class TestLevel {
  String? id;
  String? title;
  String? description;
  String? score;
  int? level;


  TestLevel({this.id, this.title, this.description, this.score, this.level});

  TestLevel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    score = json['score'];
    level = json['level'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['score'] = score;
    data['level'] = level;
    return data;
  }
}
