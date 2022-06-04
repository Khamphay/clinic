import 'dart:async';
import 'dart:convert';

import 'package:clinic/source/source.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class StreamSocket {
  final socketRespone = StreamController<String>();
  void Function(String) get addResponse => socketRespone.sink.add;
  Stream<String> get getResponse => socketRespone.stream.asBroadcastStream();
  void dispose() {
    socketRespone.close();
  }
}

class SocketController {
  static late io.Socket socket;
  // static StreamSocket stream = StreamSocket();

  static void initialSocket() {
    try {
      socket = io.io(socketUrl, <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
      });

      socket.connect();
      // socket.on("connect", (data) => print(data));
      // socket.on("send_notifi", handleMessage);
      // socket.on("message", (data) => {stream.addResponse, print(data)});
      // socket.on("disconnect", (data) => print(data));

    } on Exception {
      // print("Connect Socket Error: " + e.toString());
    }
  }

  static void sendNotification(String event, String message) {
    socket.emit(
        event,
        json.encode({
          "id": socket.id,
          "message": message,
          "timestamp": DateTime.now().microsecondsSinceEpoch
        }));
  }

  static void disconnect() {
    socket.disconnect();
  }
}
