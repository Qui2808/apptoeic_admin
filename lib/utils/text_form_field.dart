import 'package:flutter/material.dart';

class TextFormForEdit extends StatelessWidget {
  final TextEditingController controller;
  final bool isEditing;
  final String label;
  const TextFormForEdit({super.key, required this.controller, required this.isEditing, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditing,
      enabled: isEditing,
      maxLines: null, // Tự động xuống dòng khi văn bản quá dài
      style: TextStyle(
        color: isEditing ? Colors.black : Colors.black87, // Thiết lập màu sắc của văn bản dựa trên trạng thái của trường
      ),
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28.0),)
      ),
    );
  }
}



class TextFormForAdd extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  const TextFormForAdd({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: null, // Tự động xuống dòng khi văn bản quá dài
      style: const TextStyle(
          color:Colors.black
      ),
      decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28.0),)
      ),
    );
  }
}
