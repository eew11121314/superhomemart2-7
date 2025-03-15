import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferDateTimePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onDateTimeChanged;

  const TransferDateTimePicker({
    Key? key,
    this.initialDate,
    required this.onDateTimeChanged,
  }) : super(key: key);

  @override
  _TransferDateTimePickerState createState() => _TransferDateTimePickerState();
}

class _TransferDateTimePickerState extends State<TransferDateTimePicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          widget.onDateTimeChanged(_selectedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('เวลาในการโอน'),
      subtitle: Text(
        _selectedDate != null
            ? DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate!)
            : 'กรุณาเลือกเวลาในการโอน',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: _pickDateTime,
    );
  }
}
