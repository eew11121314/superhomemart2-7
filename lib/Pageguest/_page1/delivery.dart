import 'package:superhomemart2/Pageguest/_page1/gif.dart';
import 'package:flutter/material.dart';

class DeliveryPage extends StatelessWidget {
  final String productName;

  const DeliveryPage({super.key, required this.productName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF073074), // Start color
                Color(0xFF1a6f96), // End color
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Delivery Details',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Kanit',
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF073074), // Start color
              Color(0xFF1a6f96), // End color
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Product: $productName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Kanit',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Please enter your delivery details',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontFamily: 'Kanit',
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField('Full Name'),
              const SizedBox(height: 16),
              _buildTextField('Street Address'),
              const SizedBox(height: 16),
              _buildTextField('City'),
              const SizedBox(height: 16),
              _buildTextField('State/Province'),
              const SizedBox(height: 16),
              _buildTextField('Postal Code/Zip Code',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Phone Number',
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField('Delivery Instructions (optional)',
                  hintText: 'Add any specific delivery notes (optional)'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DeliveryInProgressPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                ),
                child: const Text('Confirm Delivery'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextInputType keyboardType = TextInputType.text, String? hintText}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Colors.blueAccent,
            fontFamily: 'Kanit',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(fontFamily: 'Kanit'),
      ),
    );
  }
}
