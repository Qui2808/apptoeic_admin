
class Vocabulary {
  String? id;
  String? eng;
  String? vie;
  String? spell;
  String? example;
  String? image;
  String? vocabCate;
  String? audio;


  Vocabulary(this.id, this.eng, this.vie, this.spell, this.example,
      this.image, this.vocabCate, this.audio);

  Vocabulary.fromJson(Map<String, dynamic> json) {
    id = json['vocabId'];
    eng = json['eng'];
    vie = json['vie'];
    spell = json['spell'];
    example = json['example'];
    image = json['image'];
    vocabCate = json['vocabCate'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vocabId'] = id;
    data['eng'] = eng;
    data['vie'] = vie;
    data['spell'] = spell;
    data['example'] = example;
    data['image'] = image;
    data['vocabCate'] = vocabCate;
    data['audio'] = audio;
    return data;
  }
}
