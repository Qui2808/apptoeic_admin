import 'dart:io';

import 'package:apptoeic_admin/admin_main_page.dart';
import 'package:apptoeic_admin/model/practice.dart';
import 'package:apptoeic_admin/model/testlevel.dart';
import 'package:apptoeic_admin/tab_bar_view/questions/player_widget.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/dropdown_button.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic_admin/utils/data_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/question.dart';
import '../../utils/text_form_field.dart';

class QuestionDetail extends StatefulWidget {
  final Question question;

  const QuestionDetail({Key? key, required this.question}) : super(key: key);

  @override
  _QuestionDetailState createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _img;
  final picker = ImagePicker();
  File? _image;
  File? _audio;

  late TextEditingController _contentController;
  late TextEditingController _opAController;
  late TextEditingController _opBController;
  late TextEditingController _opCController;
  late TextEditingController _opDController;

  List<String> answer = ['A', 'B', 'C', 'D'];
  String selectedAnswer = 'A';

  List<TestLevel> levels = [];
  List<Practice> practices = [];

  String selectedLevel = '';
  String selectedPractice = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.question.content);
    _opAController = TextEditingController(text: widget.question.opA);
    _opBController = TextEditingController(text: widget.question.opB);
    _opCController = TextEditingController(text: widget.question.opC);
    _opDController = TextEditingController(text: widget.question.opD);
    _img = widget.question.image;
    if(widget.question.audio != null){
      _audioPlayer.setSourceUrl(widget.question.audio!);
    }
    _loadDataDropDownButton();
    selectedLevel = widget.question.level!;
    selectedPractice = widget.question.practiceCate!;
  }

  void _loadDataDropDownButton() async {
    List<TestLevel> lv = await getTestLevelFromFireStore();
    List<Practice> pr = await getPracticeFromFireStore();
    if(lv != null){
      setState(() {
        levels = lv;
      });
    }
    if(pr != null){
      setState(() {
        practices = pr;
      });
    }
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
    super.dispose();
  }

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
        title: const Text('Question Detail'),
        backgroundColor: mainColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if(widget.question.content != null)...[
                    TextFormForEdit(
                        controller: _contentController,
                        isEditing: _isEditing,
                        label: "Content"),
                    const SizedBox(height: 16.0),
                    TextFormForEdit(
                        controller: _opAController,
                        isEditing: _isEditing,
                        label: "Option A"),
                    const SizedBox(height: 16.0),
                    TextFormForEdit(
                        controller: _opBController,
                        isEditing: _isEditing,
                        label: "Option B"),
                    const SizedBox(height: 16.0),
                    TextFormForEdit(
                        controller: _opCController,
                        isEditing: _isEditing,
                        label: "Option C"),
                    const SizedBox(height: 16.0),
                    TextFormForEdit(
                        controller: _opDController,
                        isEditing: _isEditing,
                        label: "Option D"),
                  ]
                  else...[
                    _image == null
                        ? Image.network(_img!, width: 200, height: 200)
                        : Image.file(_image!, width: 200, height: 200),
                    if(_isEditing == true)...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 20, 70, 0),
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey)),
                          child: const Text('Change Image'),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: PlayerWidget(
                            player:
                            _audioPlayer), // Pass the audio player to PlayerWidget
                      ),
                    ),

                    if(_isEditing == true)...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(70, 20, 70, 0),
                        child: ElevatedButton(
                          onPressed: _pickAudio,
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey)),
                          child: const Text('Change Audio'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16.0),
                  ],
                  const SizedBox(height: 16.0),
                  DropdownButtonForEdit(
                      lstObjects: answer,
                      selectedObject: selectedAnswer,
                      labelText: 'Answer',
                      isEditing: _isEditing),
                  const SizedBox(height: 16.0),
                  // DropdownButtonForEdit(
                  //     lstObjects: levels,
                  //     selectedObject: selectedLevel,
                  //     labelText: 'Level',
                  //     isEditing: _isEditing
                  // ),
                  DropdownButtonFormField<String>(
                    value: selectedLevel,
                    items: levels.map((TestLevel testLevel) {
                      return DropdownMenuItem<String>(
                        value: testLevel.id,
                        child: Text(' ${testLevel.score} _ ${testLevel.title} ',
                          style: TextStyle(color: _isEditing ? Colors.black : Colors.black87 ),
                        ),
                      );
                    }).toList(),
                    onChanged: _isEditing ? (String? newValue) {
                      setState(() {
                        selectedLevel = newValue!;
                      });
                    } : null,
                    decoration: InputDecoration(
                      labelText: "Level",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Màu viền khi được focus
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isEditing ? Colors.grey : Colors.grey.shade300), // Màu viền khi không được focus
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // DropdownButtonForEdit(
                  //     lstObjects: practices,
                  //     selectedObject: selectedPractice,
                  //     labelText: 'Practice',
                  //     isEditing: _isEditing),
                  DropdownButtonFormField<String>(
                    value: selectedPractice,
                    items: practices.map((Practice practice) {
                      return DropdownMenuItem<String>(
                        value: practice.idPracticeCate,
                        child: Text(' ${practice.content} - ${practice.type} ',
                          style: TextStyle(color: _isEditing ? Colors.black : Colors.black87 ),
                        ),
                      );
                    }).toList(),
                    onChanged: _isEditing ? (String? newValue) {
                      setState(() {
                        selectedPractice = newValue!;
                      });
                    } : null,
                    decoration: InputDecoration(
                      labelText: "PracticeCate",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Màu viền khi được focus
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _isEditing ? Colors.grey : Colors.grey.shade300), // Màu viền khi không được focus
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(mainColor)),
                    onPressed: _EditButtonOnClick,
                    child: Text(_isEditing ? 'Save' : 'Edit'),
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.12),
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.red.shade900)),
                    onPressed: () {
                      _showConfirmationDialog(context);
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _EditButtonOnClick() async {
    if (!_isEditing) {
      setState(() {
        _isEditing = !_isEditing;
      });
    } else {
      if (_contentController.text.trim() == "" ||
          _opAController.text.trim() == "" ||
          _opBController.text.trim() == "" ||
          _opCController.text.trim() == "" ||
          _opDController.text.trim() == "") {
        const snackBar =
            SnackBar(content: Text("Information cannot be left blank"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          _isEditing = !_isEditing;
        });
        if(widget.question.content != null){
          updateQuestion(
              widget.question.id!,
              _contentController.text,
              _opAController.text,
              _opBController.text,
              _opCController.text,
              _opDController.text,
              _getAnswerNumber(selectedAnswer),
              selectedLevel,
              selectedPractice);
        }
        else{
          String? imageUrl = await uploadImageToStorage(_image!);
          print('Image URL: $imageUrl');

          String? audioUrl = await uploadAudioToStorage(_audio!);
          print('Audio URL: $audioUrl');
          updateQuestionListening(
              widget.question.id!,
              _getAnswerNumber(selectedAnswer),
              selectedLevel,
              selectedPractice,
              imageUrl!,
              audioUrl!
          );
        }
        const snackBar = SnackBar(content: Text("Update successful"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm delete'),
          content: const Text('Are you sure you want to delete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _DeleteButtonOnClick(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _DeleteButtonOnClick(BuildContext context) {
    deleteObject('questions', widget.question.id!);
    const snackBar = SnackBar(content: Text("Delete successful"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    nextScreenReplace(context, Admin(index: 1));
  }

  int _getAnswerNumber(String answer) {
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
