import 'dart:convert';

class Vocabulary {
  String? id;
  String? en;
  String? vn;
  String? spell;
  String? love;
  String? example;
  String? image;
  String? vocabCate;
  String? audio;


  Vocabulary(this.id, this.en, this.vn, this.spell, this.love, this.example,
      this.image, this.vocabCate, this.audio);

  Vocabulary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    en = json['en'];
    vn = json['vn'];
    spell = json['spell'];
    love = json['love'];
    example = json['example'];
    image = json['image'];
    vocabCate = json['vocabCate'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['en'] = en;
    data['vn'] = vn;
    data['spell'] = spell;
    data['love'] = love;
    data['example'] = example;
    data['image'] = image;
    data['vocabCate'] = vocabCate;
    data['audio'] = audio;
    return data;
  }
}
