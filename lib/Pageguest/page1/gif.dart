import 'package:flutter/material.dart';

class DeliveryInProgressPage extends StatelessWidget {
  const DeliveryInProgressPage({super.key});

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
              'Delivery in Progress',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ของกำลังไปส่งรอก่อนนะไอ่เต่า!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Kanit',
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/Scooter Courier.gif',
                height: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
