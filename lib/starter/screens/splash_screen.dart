import 'package:flutter/material.dart';
import 'package:ietp_project/starter/providers/arduino_provider.dart';
import 'package:ietp_project/starter/screens/connection_screen.dart';
import 'package:ietp_project/starter/screens/home_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      final arduino = context.read<ArduinoProvider>();

      if (!mounted) return;

       Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );

     /*  if (arduino.isConnected) {
       
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ConnectionScreen()),
        );
      } */
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Image.asset(
                'assets/images/connect.gif',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Solar Panel Cleaner",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "IoT Control System",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
