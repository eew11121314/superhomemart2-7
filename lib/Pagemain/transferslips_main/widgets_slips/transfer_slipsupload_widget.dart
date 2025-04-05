import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TransferSlipsUploadWidget extends StatefulWidget {
  final Function(File?) onImageSelected; // Callback เมื่อเลือกภาพ

  const TransferSlipsUploadWidget({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  _TransferSlipsUploadWidgetState createState() =>
      _TransferSlipsUploadWidgetState();
}

class _TransferSlipsUploadWidgetState extends State<TransferSlipsUploadWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      widget.onImageSelected(_image); // ส่งภาพกลับไปยัง parent widget
    }
  }

  void _viewImage(BuildContext context) {
    if (_image != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(_image!),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ปิด',
                    style: TextStyle(fontFamily: 'Kanit'),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'อัปโหลดสลิปการโอนเงิน',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: _image == null
                ? Column(
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ยังไม่ได้เลือกภาพ',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: () => _viewImage(context),
                    child: Image.file(
                      _image!,
                      height: 100,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 6, 184, 3),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              child: const Text(
                'อัปโหลดสลิป',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
