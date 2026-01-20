import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/arduino_provider.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Column(
          children: const [
            Text(
              "Solar Panel Cleaner",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "IoT Control System",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),

      body: Consumer<ArduinoProvider>(
        builder: (context, arduino, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ===== GIF =====
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/connect.gif',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Searching for Arduino...",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Please power on your device",
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                // ===== Connect Button =====
              ],
            ),
          );
        },
      ),
    );
  }
}
