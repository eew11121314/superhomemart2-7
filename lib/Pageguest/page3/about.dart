import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart'; // เพิ่มการนำเข้า

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: const BoxDecoration(),
          child: AppBar(
            title: const Text(
              'About Us',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Kanit', // Apply the Kanit font
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset(
                'assets/Icon/left.svg',
                width: 30,
                height: 30,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'บริษัท ซูเปอร์โฮมมาร์ท จำกัด',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    fontFamily: 'Kanit', // Apply the Kanit font
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'ผู้จัดจำหน่ายสินค้า เครื่องมือช่าง เครื่องมือเกษตร มอเตอร์ ปั๊มน้ำ อุปกรณ์ลมและ สินค้าอุตสหกรรมต่างๆ ทั้งปลีก และ ส่ง',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Kanit'), // Apply the Kanit font
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Our Values:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Kanit', // Apply the Kanit font
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '- เครื่องมือช่าง\n- เครื่องมือเกษตร\n- ปั้มน้ำ\n- อุปกรณ์ลม\n- สินค้าอุตสหกรรม',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Kanit'), // Apply the Kanit font
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Contact Us:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Kanit', // Apply the Kanit font
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/Icon/line.svg',
                              width: 24,
                              height: 24,
                              //color: const Color(0xFF0F44A9),
                            ),
                            const SizedBox(width: 8),
                            const Text('Line: @Superhomemart',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/Icon/facebook.svg',
                              width: 24,
                              height: 24,
                              //color: const Color(0xFF0F44A9),
                            ),
                            const SizedBox(width: 8),
                            const Text('Facebook: Super home mart',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/Icon/phone.svg',
                              width: 24,
                              height: 24,
                              color: const Color(0xFF0F44A9),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Phone: 098 827 6425 \nPhone: 02 235 4941 ถึง 6',
                              style:
                                  TextStyle(fontSize: 12, fontFamily: 'Kanit'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/Icon/location.svg',
                              width: 24,
                              height: 24,
                              //color: const Color(0xFF0F44A9),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Address: 654/23 ถนนพระรามที่ 4 แขวงมหาพฤฒาราม เขตบางรัก กรุงเทพมหานคร 10500',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/Icon/youtube.svg',
                                width: 30,
                                height: 30,
                                // color: Colors.red,
                              ),
                              onPressed: () {
                                _launchURL(
                                    'https://www.youtube.com/@SuperHomeMart');
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('YouTube: SuperHomeMart',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/Icon/tiktok.svg',
                                width: 30,
                                height: 30,
                                // color: Colors.black,
                              ),
                              onPressed: () {
                                _launchURL(
                                    'https://www.tiktok.com/@superhomemart');
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('TikTok: @SuperHomeMart',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit')),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/Icon/line.svg',
                                width: 30,
                                height: 30,
                                // color: Colors.green,
                              ),
                              onPressed: () {
                                _launchURL(
                                    'https://page.line.me/134uxdhu?oat_content=url&openQrModal=true');
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('Line: @SuperHomeMart',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(
                                'assets/Icon/facebook.svg',
                                width: 30,
                                height: 30,
                                // color: Colors.blue,
                              ),
                              onPressed: () {
                                _launchURL(
                                    'https://www.facebook.com/superhomemart/');
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('Facebook: SuperHomeMart',
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Kanit')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
