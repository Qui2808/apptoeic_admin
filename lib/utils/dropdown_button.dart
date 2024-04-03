import 'package:flutter/material.dart';

class DropdownButtonForEdit extends StatefulWidget {
  final List<String> lstObjects;
  String selectedObject;
  final String labelText;
  final bool isEditing;
  DropdownButtonForEdit({super.key, required this.lstObjects, required this.selectedObject, required this.labelText, required this.isEditing});

  @override
  State<DropdownButtonForEdit> createState() => _DropdownButtonForEditState();
}

class _DropdownButtonForEditState extends State<DropdownButtonForEdit> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedObject,
      items: widget.lstObjects.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type,
            style: TextStyle(color: widget.isEditing ? Colors.black : Colors.black87 ),
          ),
        );
      }).toList(),
      onChanged: widget.isEditing ? (String? newValue) {
        setState(() {
          widget.selectedObject = newValue!;
        });
      } : null,
      decoration: InputDecoration(
        labelText: widget.labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey), // Màu viền khi được focus
          borderRadius: BorderRadius.circular(28.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.isEditing ? Colors.grey : Colors.grey.shade300), // Màu viền khi không được focus
          borderRadius: BorderRadius.circular(28.0),
        ),
      ),
    );
  }
}



class DropdownButtonForAdd extends StatefulWidget {
  final List<String> lstObjects;
  String selectedObject;
  final String labelText;
  DropdownButtonForAdd({super.key, required this.lstObjects, required this.labelText, required this.selectedObject});

  @override
  State<DropdownButtonForAdd> createState() => _DropdownButtonForAddState();
}

class _DropdownButtonForAddState extends State<DropdownButtonForAdd> {

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedObject,
      items: widget.lstObjects.map((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged:(String? newValue) {
        setState(() {
          widget.selectedObject = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28.0)),
      ),
    );
  }
}
