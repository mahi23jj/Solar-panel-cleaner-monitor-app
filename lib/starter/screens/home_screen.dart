// import 'package:flutter/material.dart';
// import 'package:ietp_project/starter/providers/cleaning_view_model.dart';
// import 'package:ietp_project/starter/screens/cleaning_screen.dart';
// import 'package:ietp_project/starter/screens/connection_screen.dart';
// import 'package:provider/provider.dart';
// import '../providers/arduino_provider.dart';

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Solar Panel Cleaner'),
//         backgroundColor: Colors.blue[800],
//         actions: [
//           Consumer<ArduinoProvider>(
//             builder: (context, arduino, child) {
//               return IconButton(
//                 icon: Icon(
//                   Icons.settings,
//                   color: arduino.isConnected ? Colors.green : Colors.red,
//                 ),
//                 onPressed: () {
//                 /*   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ConnectionScreen()),
//                   ); */
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<ArduinoProvider>(
//         builder: (context, arduino, child) {
//           if (!arduino.isConnected) {
//             print(arduino.currentData!.dustLevel.toInt());
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.bluetooth_disabled, size: 60, color: Colors.grey),
//                   SizedBox(height: 20),
//                   Text('Not connected to Arduino'),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     child: Text('CONNECT'),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ConnectionScreen(),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (arduino.currentData == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 20),
//                   Text('Waiting for data from Arduino...'),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     child: Text('GET STATUS'),
//                     onPressed: () => arduino.getStatus(),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return Column(
//             children: [
//               // Dust Level Card
//               Container(
//                 margin: EdgeInsets.all(20),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [Colors.blue[900]!, Colors.blue[800]!],
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 10,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       'REAL-TIME DUST LEVEL',
//                       style: TextStyle(
//                         color: Colors.white70,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     Text(
//                       '${arduino.currentData!.dustLevel.toInt()}',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 64,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Digital',
//                       ),
//                     ),
//                     Text(
//                       'pcs/0.01cf',
//                       style: TextStyle(color: Colors.white70, fontSize: 16),
//                     ),
//                     SizedBox(height: 20),
//                     LinearProgressIndicator(
//                       value: arduino.currentData!.dustLevel / 30000,
//                       backgroundColor: Colors.blue[800],
//                       color: arduino.currentData!.aboveThreshold
//                           ? Colors.orange
//                           : Colors.green,
//                       minHeight: 10,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Threshold: ${arduino.currentData!.threshold.toInt()}',
//                           style: TextStyle(color: Colors.white70),
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: arduino.currentData!.aboveThreshold
//                                 ? Colors.orange.withOpacity(0.3)
//                                 : Colors.green.withOpacity(0.3),
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: arduino.currentData!.aboveThreshold
//                                   ? Colors.orange
//                                   : Colors.green,
//                             ),
//                           ),
//                           child: Text(
//                             arduino.currentData!.aboveThreshold
//                                 ? '⚠️ ABOVE THRESHOLD'
//                                 : '✅ NORMAL',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 20),

//               // Control Buttons
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   children: [
//                     // Main Control Buttons
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             icon: Icon(Icons.cleaning_services),
//                             label: Text('MANUAL CLEAN'),
//                             // onPressed: () => arduino.manualClean(),
//                             onPressed: () async {
//                               // await arduino.manualClean();
//                               await arduino.startAutoCleaning();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => CleaningScreen(),
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               backgroundColor: Colors.blue[800],
//                             ),
//                           ),
//                         ),
//                        /*  SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             icon: Icon(Icons.stop),
//                             label: Text('STOP'),
//                             onPressed: () => arduino.stopAutoCleaning(),
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               backgroundColor: Colors.orange[700],
//                             ),
//                           ),
//                         ), */
//                       ],
//                     ),
//                     SizedBox(height: 10),
//                     /* Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             icon: Icon(Icons.play_arrow),
//                             label: Text('AUTO ON'),
//                             onPressed: () => arduino.startAutoCleaning(),
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               backgroundColor: Colors.green[700],
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: ElevatedButton.icon(
//                             icon: Icon(Icons.info),
//                             label: Text('STATUS'),
//                             onPressed: () => arduino.getStatus(),
//                             style: ElevatedButton.styleFrom(
//                               padding: EdgeInsets.symmetric(vertical: 15),
//                               backgroundColor: Colors.purple[700],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ), */
//                   ],
//                 ),
//               ),

//               SizedBox(height: 30),

//               // Status Indicators
//             /*   Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         Text(
//                           'SYSTEM STATUS',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         SizedBox(height: 15),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             StatusIndicator(
//                               label: 'CLEANING',
//                               active: arduino.currentData!.cleaningInProgress,
//                             ),
//                             StatusIndicator(
//                               label: 'AUTO MODE',
//                               active: arduino.currentData!.autoCleaningEnabled,
//                             ),
//                             StatusIndicator(
//                               label: 'CYCLE',
//                               value: arduino.currentData!.cycle,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ), */

//               Spacer(),

//               // Quick Messages
//              /*  if (arduino.messages.isNotEmpty)
//                 Container(
//                   margin: EdgeInsets.all(16),
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey[300]!),
//                   ),
//                   height: 80,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Recent Messages',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 12,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: 5),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: arduino.messages.length,
//                           reverse: true,
//                           itemBuilder: (context, index) {
//                             int reverseIndex =
//                                 arduino.messages.length - 1 - index;
//                             String message = arduino.messages[reverseIndex];

//                             // Show only last 3 messages
//                             if (index >= 3) return SizedBox.shrink();

//                             return Text(
//                               '• ${message.length > 40 ? message.substring(0, 40) + '...' : message}',
//                               style: TextStyle(
//                                 fontSize: 11,
//                                 color: Colors.grey[600],
//                               ),
//                               maxLines: 1,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ), */
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class StatusIndicator extends StatelessWidget {
//   final String label;
//   final bool? active;
//   final String? value;

//   StatusIndicator({required this.label, this.active, this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             color: value != null
//                 ? Colors.blue[50]
//                 : (active == true ? Colors.green[100] : Colors.grey[200]),
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: value != null
//                   ? Colors.blue
//                   : (active == true ? Colors.green : Colors.grey),
//               width: 2,
//             ),
//           ),
//           child: Center(
//             child: value != null
//                 ? Text(
//                     value!,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue[800],
//                     ),
//                   )
//                 : Icon(
//                     active == true ? Icons.check : Icons.close,
//                     color: active == true ? Colors.green : Colors.grey,
//                   ),
//           ),
//         ),
//         SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ietp_project/starter/screens/NotificationScreen.dart';
import 'package:ietp_project/starter/widget/animated_dust_gauge.dart';
import 'package:provider/provider.dart';
import '../providers/arduino_provider.dart';
import 'cleaning_screen.dart';
import 'connection_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ArduinoProvider>(
      builder: (context, arduino, _) {
        final data = arduino.currentData;

        final dust = data?.dustLevel.toDouble() ?? 0;
        final threshold = data?.threshold.toDouble() ?? 600;
        final isOnline = arduino.isConnected;
        final isCleaning = data?.cleaningInProgress ?? false;
        final aboveThreshold = data?.aboveThreshold ?? false;
        final thresholdDisplay = threshold.toInt();

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
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
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: const Color(0xFF7E57C2)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationScreen()),
                  );
                },
              ),
            ],
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),

                // ===== Dust Card =====
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Real-Time Dust Level",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        dust.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "pcs/0.01cf",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      // ===== Gauge =====
                      AnimatedDustGauge(value: dust, max: threshold),

                      /* SizedBox(
                        height: 120,
                        width: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: (dust / threshold).clamp(0.0, 1.0),
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation(
                                dust >= threshold
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                            Icon(
                              Icons.speed,
                              color: Colors.grey.shade400,
                            ),
                          ],
                        ),
                      ), */
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Threshold: $thresholdDisplay',
                            style: TextStyle(color: Colors.transparent),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: aboveThreshold
                                  ? Colors.orange.withOpacity(0.3)
                                  : Colors.green.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: aboveThreshold
                                    ? Colors.orange
                                    : Colors.green,
                              ),
                            ),
                            child: Text(
                              aboveThreshold
                                  ? '⚠️ ABOVE THRESHOLD'
                                  : '✅ NORMAL',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ===== Power Button =====
                GestureDetector(
                  onTap: () async {
                    await arduino.startAutoCleaning();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CleaningScreen()),
                    );
                  },

                  /* !isOnline
                      ? null
                      : () async {
                          if (isCleaning) {
                            await arduino.stopAutoCleaning();
                          } else {
                            
                          }
                        } */
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCleaning ? Colors.red : Colors.green,
                      boxShadow: [
                        BoxShadow(
                          color: (isCleaning ? Colors.red : Colors.green)
                              .withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.power_settings_new,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ===== Status Text - about auto cleaning =====
                /*   Text(
                  isOnline ? "ONLINE" : "OFFLINE",
                  style: TextStyle(
                    color: isOnline ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ), */
              ],
            ),
          ),
        );
      },
    );
  }
}
