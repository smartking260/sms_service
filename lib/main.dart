import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  requestPermissions();
  listenIncomingSms();

  runApp(const MyApp());
}

// to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch

void requestPermissions() async {
  final status = await Permission.sms.status;
  if (!status.isGranted) {
    await Permission.sms.request();
  }
}

final Telephony telephony = Telephony.instance;

void listenIncomingSms() {
  telephony.listenIncomingSms(
      onNewMessage: onMessage, listenInBackground: true, onBackgroundMessage: onMessage);
}

Future<void> onMessage(SmsMessage message) async {
  // This is where you can read the message
  print("Sender: ${message.address}");
  print("Message: ${message.body}");

  String _numbersWithLength13 = '';
  String _numbersWithLength8 = '';

  final regex13 = RegExp(r'\b\d{13}\b');
  final regex8 = RegExp(r'\b\d{8}\b');
  final matches13 = regex13.allMatches(message.body.toString());
  final matches8 = regex8.allMatches(message.body.toString());
  _numbersWithLength13 = matches13.map((match) => match.group(0)!).join('');
  _numbersWithLength8 = matches8.map((match) => match.group(0)!).join('');
  if (_numbersWithLength13.length == 13 && _numbersWithLength8.length == 8) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.show(
      1,
      'سیبانک',
      'پیامک قبض دریافت شد لطفا نسبت به پرداخت اقدام کنید',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'my_foreground',
          'MY FOREGROUND SERVICE',
          icon: 'ic_bg_service_small',
          ongoing: true,
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service App'),
        ),
        body: LogView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}

class LogView extends StatefulWidget {
  const LogView({Key? key}) : super(key: key);

  @override
  State<LogView> createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  late final Timer timer;
  List<String> logs = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
