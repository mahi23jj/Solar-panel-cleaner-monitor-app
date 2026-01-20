// // main.dart

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:ietp_project/providers/BluetoothProvider.dart';
// import 'package:ietp_project/providers/CleaningProvider.dart';
// import 'package:ietp_project/providers/NotificationProvider.dart';
// import 'package:ietp_project/screens/NotificationsScreen.dart';
// import 'package:ietp_project/services/notification_service.dart';
// import 'package:provider/provider.dart';
// import 'screens/dashboard_screen.dart';
// import 'screens/history_screen.dart';
// import 'screens/settings_screen.dart';
// import 'services/hive_service.dart';
// import 'services/sync_service.dart';
// import 'services/bluetooth_mock_service.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:bluetooth_classic/bluetooth_classic.dart';
// import 'package:bluetooth_classic/models/device.dart';
// import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ietp_project/starter/model/hive_model.dart';
import 'package:ietp_project/starter/providers/arduino_provider.dart';
import 'package:ietp_project/starter/providers/cleaning_view_model.dart';
import 'package:ietp_project/starter/screens/cleaning_screen.dart';
import 'package:ietp_project/starter/screens/connection_screen.dart';
import 'package:ietp_project/starter/screens/home_screen.dart';
import 'package:ietp_project/starter/screens/splash_screen.dart';
import 'package:ietp_project/starter/widget/in_app_notification.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeHive();

  // Hive.registerAdapter(HiveCleaningNotificationAdapter());

  // Open the box in main
  final notificationBox = await Hive.openBox<HiveCleaningNotification>(
    'notifications',
  );
  runApp(MyApp(notificationBox: notificationBox));
}

Future<void> _initializeHive() async {
  // Get application documents directory
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  // Initialize Hive with the path
  Hive.init(appDocumentDir.path);

  // Register adapter
  Hive.registerAdapter(HiveCleaningNotificationAdapter());

  // Open the box

  // await Hive.openBox<HiveCleaningNotification>('notifications');
}

class MyApp extends StatelessWidget {
  final Box<HiveCleaningNotification> notificationBox;

  const MyApp({super.key, required this.notificationBox});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ArduinoProvider(
            (isAuto) => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CleaningScreen()),
            ),
            notificationBox: notificationBox,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Solar Panel Cleaner',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        debugShowCheckedModeBanner: false,

        home: const AppRoot(),
      ),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main app navigation
          Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(builder: (_) => const SplashScreen());
            },
          ),

          // Global in-app notifications (ALWAYS ON TOP)
          const InAppNotificationOverlay(),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: BluetoothPage(),
//     );
//   }
// }

// class BluetoothPage extends StatefulWidget {
//   const BluetoothPage({super.key});

//   @override
//   State<BluetoothPage> createState() => _BluetoothPageState();
// }

// class _BluetoothPageState extends State<BluetoothPage> {
//   final BluetoothClassic _bluetooth = BluetoothClassic();
//   List<Device> devices = [];
//   bool isScanning = false;

//   @override
//   void initState() {
//     super.initState();
//     _initBluetooth();
//   }

//   Future<void> _initBluetooth() async {
//     // Init permissions from bluetooth_classic
//     await _bluetooth.initPermissions();

//     // Request runtime permissions using permission_handler
//     await [
//       Permission.bluetooth,
//       Permission.bluetoothScan,
//       Permission.bluetoothConnect,
//       Permission.location,
//     ].request();
//   }

//   void _scanDevices() async {
//     setState(() {
//       devices.clear();
//       isScanning = true;
//     });

//     await _bluetooth.startScan();

//     // Listen for discovered devices
//     _bluetooth.onDeviceDiscovered().listen((Device device) {
//       setState(() {
//         if (!devices.any((d) => d.address == device.address)) {
//           devices.add(device);
//         }
//       });
//     });

//     // Stop scanning after 10 seconds
//     await Future.delayed(const Duration(seconds: 10));
//     await _bluetooth.stopScan();
//     setState(() {
//       isScanning = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Bluetooth Classic")),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: isScanning ? null : _scanDevices,
//             child: Text(isScanning ? "Scanning..." : "Scan"),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: devices.length,
//               itemBuilder: (_, i) {
//                 final d = devices[i];
//                 return ListTile(
//                   title: Text(d.name ?? "Unknown"),
//                   subtitle: Text(d.address),
//                   trailing: ElevatedButton(
//                     child: const Text("Connect"),
//                     onPressed: () async {
//                       // Example: connect to the device
//                      /*  bool connected = await _bluetooth.connect(d);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                               connected ? "Connected to ${d.name}" : "Failed"),
//                         ),
//                       ); */
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

/*class _BluetoothPageState extends State<BluetoothPage> {
  final BluetoothClassic _bluetooth = BluetoothClassic();
  List<BluetoothDevice> devices = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _initBluetooth();
  }

  Future<void> _initBluetooth() async {
    await _bluetooth.
    // requestEnable();
  }

  Future<void> _scanDevices() async {
    setState(() {
      devices.clear();
      isScanning = true;
    });

    final foundDevices = await _bluetooth.onDeviceDiscovered();

    setState(() {
      devices = foundDevices;
      isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Classic Scan')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isScanning ? null : _scanDevices,
            child: Text(isScanning ? 'Scanning...' : 'Scan Devices'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final d = devices[index];
                return ListTile(
                  title: Text(d.name ?? 'Unknown'),
                  subtitle: Text(d.id as String),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
 */

// void main() {
//   FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
//   runApp(const FlutterBlueApp());
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize services
//   final hiveService = HiveService();
//   await hiveService.init();

//   final notificationService = LocalNotificationService();
//   await notificationService.initialize();

//   // final syncService = SyncService();
//   // await syncService.init(enableFirebase: false);

//   // final bluetoothService = BluetoothMockService();

//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<HiveService>(create: (_) => hiveService),
//         Provider<LocalNotificationService>(create: (_) => notificationService),
//         // Provider<SyncService>(create: (_) => syncService),
//         // Provider<BluetoothMockService>(create: (_) => bluetoothService),

//         // Providers with dependencies
//         ChangeNotifierProvider<CleaningProvider>(
//           create: (context) => CleaningProvider(
//             // Provider.of<HiveService>(context, listen: false),
//           ),
//         ),

//         ChangeNotifierProvider<NotificationProvider>(
//           create: (context) => NotificationProvider(
//            /*  Provider.of<LocalNotificationService>(context, listen: false),
//             Provider.of<HiveService>(context, listen: false), */
//           ),
//         ),

//         // ChangeNotifierProvider<SyncProvider>(
//         //   create: (context) => SyncProvider(
//         //     Provider.of<SyncService>(context, listen: false),
//         //   ),
//         // ),

//         ChangeNotifierProvider<BluetoothProvider>(
//           create: (context) => BluetoothProvider(
//             // Provider.of<BluetoothMockService>(context, listen: false),
//           ),
//         ),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Solar Panel Cleaner',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         useMaterial3: true,
//       ),
//       home: MainScreen(),
//       routes: {
//         '/dashboard': (context) => DashboardScreen(),
//         '/history': (context) => HistoryScreen(),
//         '/notifications': (context) => NotificationsScreen(),
//         // '/settings': (context) => SettingsScreen(),
//       },
//     );
//   }
// }

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    // DashboardScreen(),
    // HistoryScreen(),
    // NotificationsScreen(),
    // SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              child: const Icon(Icons.notifications),
              /*  label: Consumer<NotificationProvider>(
                builder: (context, provider, child) {
                  return const Text('${provider.unreadCount}');
                },
              ), */
            ),
            label: 'Notifications',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }



// class MyHomePage extends StatelessWidget {
//   const MyHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Bluetooth Test')),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               StreamBuilder<BluetoothAdapterState>(
//                 stream: FlutterBluePlus.adapterState,
//                 initialData: BluetoothAdapterState.unknown,
//                 builder: (c, snapshot) {
//                   final state = snapshot.data;
//                   if (state == BluetoothAdapterState.on) {
//                     return const Column(
//                       children: [
//                         Icon(Icons.bluetooth, color: Colors.blue, size: 100),
//                         SizedBox(height: 20),
//                         Text('Bluetooth is ON!', 
//                              style: TextStyle(fontSize: 24, color: Colors.green)),
//                         Text('Ready to scan', 
//                              style: TextStyle(fontSize: 16)),
//                       ],
//                     );
//                   } else if (state == BluetoothAdapterState.off) {
//                     return const Column(
//                       children: [
//                         Icon(Icons.bluetooth_disabled, color: Colors.red, size: 100),
//                         SizedBox(height: 20),
//                         Text('Bluetooth is OFF', 
//                              style: TextStyle(fontSize: 24, color: Colors.red)),
//                         Text('Please enable Bluetooth', 
//                              style: TextStyle(fontSize: 16)),
//                       ],
//                     );
//                   }
//                   return const CircularProgressIndicator();
//                 },
//               ),
//               const SizedBox(height: 50),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (await FlutterBluePlus.isAvailable == false) {
//                     print("Bluetooth not available");
//                     return;
//                   }
                  
//                   // Start scanning
//                   FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
                  
//                   // Listen to results
//                   FlutterBluePlus.scanResults.listen((results) {
//                     for (var result in results) {
//                       print("Found device: ${result.device.name} - ${result.device.id}");
//                     }
//                   });
//                 },
//                 child: const Text('Test Scan'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }