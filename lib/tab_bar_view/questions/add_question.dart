import 'dart:io';

import 'package:apptoeic_admin/admin_main_page.dart';
import 'package:apptoeic_admin/tab_bar_view/questions/player_widget.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/dropdown_button.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:apptoeic_admin/utils/text_form_field.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  CollectionReference ques = FirebaseFirestore.instance.collection('questions');

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _opAController = TextEditingController();
  final TextEditingController _opBController = TextEditingController();
  final TextEditingController _opCController = TextEditingController();
  final TextEditingController _opDController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  bool _checkTypePractice = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_audioPlayer != null) {
      _audioPlayer.stop(); // Hoặc _audioPlayer.pause()
      _audioPlayer.dispose();
    }
    _contentController.dispose();
    _opAController.dispose();
    _opBController.dispose();
    _opCController.dispose();
    _opDController.dispose();
    _answerController.dispose();

    super.dispose();
  }

  List<String> answer = ['A', 'B', 'C', 'D'];
  String selectedAnswer = 'A';

  List<String> levels = ['300 - 500', '500 - 700', '700 - 900'];
  String selectedLevel = '300 - 500';

  List<String> practices = [
    'Complete The Sentences - Reading',
    'Text Completion - Reading',
    'Reading Comprehension - Reading',
    'Photographs - Listening',
    'Question Response - Listening',
    'TConversations - Listening'
  ];
  String selectedPractice = 'Complete The Sentences - Reading';

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

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: 'gs://apptoeic-a4ce0.appspot.com',
      );

      // Xác định định dạng của ảnh
      String contentType = 'image/jpg'; // Hoặc 'image/jpeg' tùy thuộc vào định dạng của ảnh

      var metadata = SettableMetadata(contentType: contentType);

      TaskSnapshot task = await storage
          .ref('ListeningImage/${DateTime.now()}.jpg')
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

  Future<String?> uploadAudioToStorage(File audioFile) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
        bucket: 'gs://apptoeic-a4ce0.appspot.com',
      );

      // Đặt định dạng loại của tệp âm thanh là audio/mpeg
      var metadata = SettableMetadata(contentType: 'audio/mpeg');

      // Tải tệp âm thanh lên lưu trữ
      TaskSnapshot task = await storage
          .ref('audio/${DateTime.now()}.mp3')
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
        title: const Text('Add question'),
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedPractice,
                  items: practices.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged:(String? newValue) {
                    setState(() {
                      selectedPractice = newValue!;
                      if(selectedPractice.contains("Listening")){
                       _checkTypePractice = true;
                      }
                      else{
                        _checkTypePractice = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Level",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.0)),
                  ),
                ),
                const SizedBox(height: 16.0),
                if (_checkTypePractice == false)...[
                TextFormForAdd(controller: _contentController, label: "Content"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _opAController, label: "Option A"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _opBController, label: "Option B"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _opCController, label: "Option C"),
                const SizedBox(height: 16.0),
                TextFormForAdd(controller: _opDController, label: "Option D"),
                const SizedBox(height: 16.0),
                ],
                //TextFormForAdd(controller: _answerController, label: "Answer"),
                DropdownButtonForAdd(
                  lstObjects: answer,
                  labelText: 'Answer',
                  selectedObject: selectedAnswer,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonForAdd(
                    lstObjects: levels,
                    labelText: 'Level',
                    selectedObject: selectedLevel,
                ),
                if (_checkTypePractice == true)...[
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
                ],

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
    if (_checkTypePractice == false){
      return ques.add({
        'content': _contentController.text,
        'image': null,
        'audio': null,
        'opA': _opAController.text,
        'opB': _opBController.text,
        'opC': _opCController.text,
        'opD': _opDController.text,
        'answer': _getAnswerNumber(_answerController.text.trim()),
        //'level': selectedLevel,
        'level': "Z6Ab07u7bWL9WJlRg9El",
        //'questionCate': selectedPractice,
        'questionCate': "OQ2oZSDQDIkHbNOnHrWT",
        // 42
      }).then((DocumentReference docRef) {
        print("Question Added with ID: ${docRef.id}");
        // Sau khi thêm, gán ID vào thuộc tính id của question
        ques.doc(docRef.id).update({'id': docRef.id});
        nextScreenReplace(context, const Admin(index: 1));
      }).catchError((error) => print("Failed to add question: $error"));
    }
    else{
      String? imageUrl = await uploadImageToStorage(_image!);
      print('Image URL: $imageUrl');

      String? audioUrl = await uploadAudioToStorage(_audio!);
      print('Audio URL: $audioUrl');
      return ques.add({
        'content': null,
        'image': imageUrl,
        'audio': audioUrl,
        'opA': "A",
        'opB': "B",
        'opC': "C",
        'opD': "D",
        'answer': _getAnswerNumber(_answerController.text.trim()),
        //'level': selectedLevel,
        'level': "Z6Ab07u7bWL9WJlRg9El",
        //'questionCate': selectedPractice,
        'questionCate': "OQ2oZSDQDIkHbNOnHrWT",
        // 42
      }).then((DocumentReference docRef) {
        print("Question Added with ID: ${docRef.id}");
        // Sau khi thêm, gán ID vào thuộc tính id của question
        ques.doc(docRef.id).update({'id': docRef.id});
        nextScreenReplace(context, const Admin(index: 1));
      }).catchError((error) => print("Failed to add question: $error"));
    }
  }

  int _getAnswerNumber(String answer){
    switch (answer) {
      case 'A':
        return 1;
      case 'B':
        return 2;
      case 'C':
        return 3;
      case 'D':
        return 4;
      default:
        return 1;
    }
  }
}
