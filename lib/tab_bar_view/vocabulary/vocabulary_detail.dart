import 'dart:io';

import 'package:apptoeic_admin/admin_main_page.dart';
import 'package:apptoeic_admin/model/testlevel.dart';
import 'package:apptoeic_admin/model/vocabcategory.dart';
import 'package:apptoeic_admin/model/vocabulary.dart';
import 'package:apptoeic_admin/tab_bar_view/questions/player_widget.dart';
import 'package:apptoeic_admin/utils/constColor.dart';
import 'package:apptoeic_admin/utils/next_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:apptoeic_admin/utils/data_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/text_form_field.dart';

class VocabularyDetail extends StatefulWidget {
  final Vocabulary vocabulary;

  const VocabularyDetail({Key? key, required this.vocabulary}) : super(key: key);

  @override
  _VocabularyDetailState createState() => _VocabularyDetailState();
}

class _VocabularyDetailState extends State<VocabularyDetail> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _img;
  final picker = ImagePicker();
  File? _image;
  File? _audio;

  late TextEditingController _engController;
  late TextEditingController _exampleController;
  late TextEditingController _vieController;
  late TextEditingController _spellController;

  List<VocabCategory> categories = [];

  String selectedCategory = '';

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _engController = TextEditingController(text: widget.vocabulary.eng);
    _vieController = TextEditingController(text: widget.vocabulary.vie);
    _exampleController = TextEditingController(text: widget.vocabulary.example);
    _spellController = TextEditingController(text: widget.vocabulary.spell);
    _img = widget.vocabulary.image;
    if(widget.vocabulary.audio != null){
      _audioPlayer.setSourceUrl(widget.vocabulary.audio!);
    }
    _loadDataDropDownButton();
    selectedCategory = widget.vocabulary.vocabCate!;

  }

  void _loadDataDropDownButton() async {
    List<VocabCategory> c = await getVocabCategoryFromFireStore();
    if(c != null){
      setState(() {
        categories = c;
      });
    }
  }

  @override
  void dispose() {
    if (_audioPlayer != null) {
      _audioPlayer.stop(); // Hoặc _audioPlayer.pause()
      _audioPlayer.dispose();
    }
    _exampleController.dispose();
    _engController.dispose();
    _vieController.dispose();
    _spellController.dispose();
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
        title: const Text('Vocabulary Detail'),
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
                  TextFormForEdit(
                      controller: _engController,
                      isEditing: _isEditing,
                      label: "Eng"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _vieController,
                      isEditing: _isEditing,
                      label: "Vie"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _spellController,
                      isEditing: _isEditing,
                      label: "Spell"),
                  const SizedBox(height: 16.0),
                  TextFormForEdit(
                      controller: _exampleController,
                      isEditing: _isEditing,
                      label: "Example"),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    items: categories.map((VocabCategory c) {
                      return DropdownMenuItem<String>(
                        value: c.cateId,
                        child: Text(c.cateName!,
                          style: TextStyle(color: _isEditing ? Colors.black : Colors.black87 ),
                        ),
                      );
                    }).toList(),
                    onChanged: _isEditing ? (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    } : null,
                    decoration: InputDecoration(
                      labelText: "Category",
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
                  _image == null
                      ? Image.network(_img!, width: 200, height: 200)
                      : Image.file(_image!, width: 200, height: 200),
                  if(_isEditing == true)...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 20, 70, 0),
                      child: ElevatedButton(
                        onPressed: (){
                          _audioPlayer.pause();
                          _pickImage;
                          },
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
                        onPressed: (){
                          _audioPlayer.pause();
                          _pickAudio;
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey)),
                        child: const Text('Change Audio'),
                      ),
                    ),
                  ],
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
      if (_engController.text.trim() == "" ||
          _vieController.text.trim() == "" ||
          _spellController.text.trim() == "" ||
          _exampleController.text.trim() == "" ) {
        const snackBar =
        SnackBar(content: Text("Information cannot be left blank"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        String? imageUrl = await uploadImageToStorage(_image!, _engController.text);
        print('Image URL: $imageUrl');

        String? audioUrl = await uploadAudioToStorage(_audio!, _engController.text);
        print('Audio URL: $audioUrl');
        setState(() {
          _isEditing = !_isEditing;
        });
        Vocabulary v = Vocabulary(widget.vocabulary.id, _engController.text, _vieController.text, _spellController.text, _exampleController.text, imageUrl, selectedCategory, audioUrl);
        updateVocabulary(v);
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
    // deleteObject('vocab', widget.vocabulary.id!);
    // const snackBar = SnackBar(content: Text("Delete successful"));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // nextScreenReplace(context, Admin(index: 4));
  }

}
