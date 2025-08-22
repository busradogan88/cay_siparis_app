import 'package:flutter/material.dart';

class DropdownButtonExample extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String?>? onChanged;
  
  const DropdownButtonExample({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged

  });

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  late String dropdownValue;
  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue; // Başlangıç değeri
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: null,
        onChanged: (String? value) {
          
          setState(() {
            dropdownValue = value!;
          });
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }
}
