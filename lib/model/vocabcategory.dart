
class VocabCategory {
  String? cateId;
  String? cateName;


  VocabCategory({this.cateId, this.cateName});

  VocabCategory.fromJson(Map<String, dynamic> json) {
    cateId = json['cateId'];
    cateName = json['cateName'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cateId'] = cateId;
    data['cateName'] = cateName;

    return data;
  }
}
