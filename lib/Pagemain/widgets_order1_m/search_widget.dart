import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final Function(String) onSearch;
  final Function onCancel;

  const SearchWidget({
    Key? key,
    required this.onSearch,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'ค้นหาสินค้า...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kanit'),
            ),
            style: const TextStyle(color: Colors.black, fontFamily: 'Kanit'),
            cursorColor: Colors.black,
            onChanged: onSearch,
          ),
        ),
      ],
    );
  }
}
