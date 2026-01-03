import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: const Color(0xFFFFD8EA),
        iconTheme: const IconThemeData(color: Color(0xFF4B3351)),
      ),
      backgroundColor: const Color(0xFFFFF6F3), 
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFFFFEAF4),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "We’d love to hear from you 💕",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4B3351),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Email: danah@gmail.com\nPhone: +961 88 888 888",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF4B3351),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
