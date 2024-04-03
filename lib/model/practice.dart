
class Practice {
  String? idPracticeCate;
  String? content;
  String? type;



  Practice({this.idPracticeCate, this.content, this.type});

  Practice.fromJson(Map<String, dynamic> json) {
    idPracticeCate = json['IDPracticeCate'];
    content = json['Content'];
    type = json['Type'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['IDPracticeCate'] = idPracticeCate;
    data['Content'] = content;
    data['Type'] = type;

    return data;
  }
}
