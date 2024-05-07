import 'dart:io';

import 'package:apptoeic_admin/admin_main_page.dart';
import 'package:apptoeic_admin/tab_bar_view/questions/player_widget.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:apptoeic_admin/utils/text_form_field.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/vocabcategory.dart';
import '../../utils/data_helper.dart';

class AddVocabulary extends StatefulWidget {
  @override
  _AddVocabularyState createState() => _AddVocabularyState();
}

class _AddVocabularyState extends State<AddVocabulary> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  CollectionReference vocab = FirebaseFirestore.instance.collection('vocab');

  final TextEditingController _engController = TextEditingController();
  final TextEditingController _vieController = TextEditingController();
  final TextEditingController _spellController = TextEditingController();
  final TextEditingController _exampleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataDropDownButton();
  }

  @override
  void dispose() {
    if (_audioPlayer != null) {
      _audioPlayer.stop(); // Hoặc _audioPlayer.pause()
      _audioPlayer.dispose();
    }
    _engController.dispose();
    _vieController.dispose();
    _spellController.dispose();
    _exampleController.dispose();

    super.dispose();
  }

  List<VocabCategory> categories = [];
  String selectedCategory = '';

  void _loadDataDropDownButton() async {
    List<VocabCategory> c = await getVocabCategoryFromFireStore();
    print(c.length);
    if(c != null){
      setState(() {
        selectedCategory = c[0].cateId!;
        categories = c;
      });
    }
  }

  File? _image;
  File? _audio;

  final picker = ImagePicker();
  final audioPlayer = AudioPlayer();

  Future<void> _pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  Future<String?> uploadImageToStorage(File imageFile, String vocab) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: 'gs://apptoeic-a4ce0.appspot.com',
      );

      // Xác định định dạng của ảnh
      String contentType = 'image/jpg'; // Hoặc 'image/jpeg' tùy thuộc vào định dạng của ảnh

      var metadata = SettableMetadata(contentType: contentType);

      TaskSnapshot task = await storage
          .ref('vocabImage/${vocab}_${DateTime.now()}.jpg')
          .putFile(imageFile, metadata);

      // Lấy đường dẫn URL của tệp đã tải lên
      String imageUrl = await task.ref.getDownloadURL();

      print('Upload to storage successful!');
      return imageUrl;
    } catch (e) {
      print('Error uploading to storage: $e');
      return null;
    }
  }



  Future<void> _pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );
    setState(() {
      if (result != null) {
        _audio = File(result.files.single.path!);
        _audioPlayer.setSourceDeviceFile(result.files.single.path!);
      }
    });
  }

  Future<String?> uploadAudioToStorage(File audioFile, String vocab) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: 'gs://apptoeic-a4ce0.appspot.com',
      );

      // Đặt định dạng loại của tệp âm thanh là audio/mpeg
      var metadata = SettableMetadata(contentType: 'audio/mpeg');

      // Tải tệp âm thanh lên lưu trữ
      TaskSnapshot task = await storage
          .ref('vocabAudio/${vocab}_${DateTime.now()}.mp3')
          .putFile(audioFile, metadata);

      // Lấy đường dẫn URL của tệp đã tải lên
      String audioUrl = await task.ref.getDownloadURL();

      print('Upload audio to storage successful!');
      return audioUrl;
    } catch (e) {
      print('Error uploading audio to storage: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vocabulary'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormForAdd(controller: _engController, label: "Eng"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _vieController, label: "Vie"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _spellController, label: "Spell"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _exampleController, label: "Example"),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: categories.map((VocabCategory cate) {
                    return DropdownMenuItem<String>(
                      value: cate.cateId,
                      child: Text(cate.cateName!),
                    );
                  }).toList(),
                  onChanged:(String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.0)),
                  ),
                ),
                  const SizedBox(height: 16.0),
                  _image == null
                      ? Image.asset(
                    'assets/no_picture_available.jpg',
                    width: 200,
                    height: 200,
                  )
                      : Image.file(_image!, width: 200, height: 200),
                  ElevatedButton(
                    onPressed: _pickImage,
                    // style: ButtonStyle(
                    //     backgroundColor: MaterialStateProperty.all(mainColor)),
                    child: const Text('Upload Image'),
                  ),
                  const SizedBox(height: 16.0),
                  (_audio == null)
                      ? ElevatedButton(
                    onPressed: _pickAudio,
                    child: const Text('Upload Audio'),
                  )
                  // : (_audioUrl == null)
                  //     ? ElevatedButton(
                  //         onPressed: () async {
                  //           await _uploadAudio();
                  //           ScaffoldMessenger.of(context)
                  //               .showSnackBar(const SnackBar(
                  //             content: Text('Audio uploaded successfully'),
                  //           ));
                  //         },
                  //         child: const Text('Confirm Upload Audio File'),
                  //         style: ButtonStyle(
                  //             backgroundColor:
                  //                 MaterialStateProperty.all(Colors.green)),
                  //       )
                      : Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: PlayerWidget(
                          player:
                          _audioPlayer), // Pass the audio player to PlayerWidget
                    ),
                  ),
                const SizedBox(height: 26.0),
                ElevatedButton(
                  onPressed: _addQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    minimumSize:
                    Size(MediaQuery.of(context).size.width * 0.6, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'ADD',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addQuestion() async {
      String? imageUrl = await uploadImageToStorage(_image!, _engController.text);
      print('Image URL: $imageUrl');

      String? audioUrl = await uploadAudioToStorage(_audio!, _engController.text);
      print('Audio URL: $audioUrl');
      return vocab.add({
        'image': imageUrl,
        'audio': audioUrl,
        'eng': _engController.text,
        'vie': _vieController.text,
        'spell': _spellController.text,
        'example': _exampleController.text,
        'vocabCate': selectedCategory,
      }).then((DocumentReference docRef) {
        print("Vocab Added with ID: ${docRef.id}");
        // Sau khi thêm, gán ID vào thuộc tính id
        vocab.doc(docRef.id).update({'vocabId': docRef.id});
        nextScreenReplace(context, const Admin(index: 4));
      }).catchError((error) => print("Failed to add question: $error"));
  }
}
