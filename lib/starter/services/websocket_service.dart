import 'dart:async';
import 'package:ietp_project/starter/model/notification_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  final StreamController<String> _dataStream =
      StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataStream.stream;

  // ================= CONNECT =================
   Future<bool> connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.4.1:81'));


      print('input connection $_channel');

      _channel!.stream.listen( 
        (data) {
          if (!_isConnected) {
            _isConnected = true;
            _dataStream.add("CONNECTED");
          }

          if (data != null) {
            _dataStream.add(data.toString());
          }
        },
        onDone: () {
          _isConnected = false;
          _dataStream.add("DISCONNECTED");
        },
        onError: (e) {
          _isConnected = false;
          _dataStream.add("ERROR:$e");
        },
        cancelOnError: true,
      );

      return true;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  // class WebSocketService {
  /* WebSocketChannel? _channel;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  final StreamController<String> _dataStream =
      StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataStream.stream;

  // ================= CONNECT =================
  Future<bool> connect() async {
    try {
      /*    _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      ); */

      final _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );

      _isConnected = true;
      _dataStream.add("CONNECTED");

      _channel!.stream.listen(
        (data) {
          if (data != null) {
            _dataStream.add(data.toString());
          }
        },
        onDone: () {
          _isConnected = false;
          _dataStream.add("DISCONNECTED");
        },
        onError: (e) {
          _isConnected = false;
          _dataStream.add("ERROR:$e");
        },
      );

      return true;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  } */

  /* WebSocketChannel? _channel;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  final StreamController<String> _dataStream =
      StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataStream.stream;

  // ================= CONNECT =================
  Future<bool> connect() async {
    try {
      /*    _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      ); */

      final _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );

      _isConnected = true;
      _dataStream.add("CONNECTED");

      _channel!.stream.listen(
        (data) {
          if (data != null) {
            _dataStream.add(data.toString());
          }
        },
        onDone: () {
          _isConnected = false;
          _dataStream.add("DISCONNECTED");
        },
        onError: (e) {
          _isConnected = false;
          _dataStream.add("ERROR:$e");
        },
      );

      return true;
    } catch (e) {
      _isConnected = false;
      return false;
    }
  } */

  // ================= SEND =================
  Future<bool> sendCommand(String command) async {
    if (!_isConnected || _channel == null) return false;

    try {
      _channel!.sink.add(command);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ================= DISCONNECT =================
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _isConnected = false;
    _dataStream.add("DISCONNECTED");
  }

  // ================= CLEANUP =================
  void dispose() {
    _dataStream.close();
    _channel?.sink.close();
  }
}
