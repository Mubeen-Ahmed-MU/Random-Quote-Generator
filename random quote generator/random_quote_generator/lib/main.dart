import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  runApp(RandomQuoteGenerator());
}

class RandomQuoteGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuotePage(),
    );
  }
}

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<String> quotes = [
    "The greatest glory in living lies not in never falling, but in rising every time we fall. - Nelson Mandela",
    "The way to get started is to quit talking and begin doing. - Walt Disney",
    "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
    "If life were predictable it would cease to be life, and be without flavor. - Eleanor Roosevelt",
    "Life is what happens when you're busy making other plans. - John Lennon",
    "The only way to do great work is to love what you do.",
    "In the middle of difficulty lies opportunity.",
    "Success is not final, failure is not fatal: It is the courage to continue that counts.",
    "Believe you can and you're halfway there.",
    "You miss 100% of the shots you don't take.",
    "The future belongs to those who believe in the beauty of their dreams.",
    "The only limit to our realization of tomorrow will be our doubts of today.",
    "Success is not the key to happiness. Happiness is the key to success.",
    "The best revenge is massive success.",
    "The only thing standing between you and your goal is the story you keep telling yourself as to why you can't achieve it.",
    "If you want to achieve greatness stop asking for permission.",
    "The road to success and the road to failure are almost exactly the same.",
    "The function of leadership is to produce more leaders, not more followers.",
    "The biggest risk is not taking any risk... In a world that's changing quickly, the only strategy that is guaranteed to fail is not taking risks.",
    "Success is walking from failure to failure with no loss of enthusiasm.",
    "You must expect great things of yourself before you can do them.",
    "The only place where success comes before work is in the dictionary.",
    "Don't be afraid to give up the good to go for the great.",
    "You are never too old to set another goal or to dream a new dream.",
    "The only person you should try to be better than is the person you were yesterday."
  ];

  String currentQuote = '';

  @override
  void initState() {
    super.initState();
    initializeNotifications();
    startQuoteNotifications();
  }

  Future<void> initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(String quote) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'random_quote_channel',
      'Random Quote',
      // 'Display a random quote',
      // importance: Importance.max,
      // priority: Priority.high,
      // ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Random Quote',
      quote,
      platformChannelSpecifics,
      payload: 'random_quote',
    );
  }

  void generateQuote() {
    final random = Random();
    final index = random.nextInt(quotes.length);
    setState(() {
      currentQuote = quotes[index];
      showNotification(currentQuote);
    });
  }

  void startQuoteNotifications() {
    const interval = Duration(seconds: 2); // Change this to set the interval
    Timer.periodic(interval, (Timer timer) {
      generateQuote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Transform.rotate(
              angle: 180 * pi / 180,
              child: Icon(
                Icons.format_quote_sharp,
                size: 40,
                color: Colors.white,
              ),
            ),
            Text(
              'Random Quote Generator',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Icon(
              Icons.format_quote_sharp,
              size: 40,
              color: Colors.white,
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xff33ccff),
                Color(0xffff99cc),
              ]),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentQuote,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: generateQuote,
                  child: Text(
                    'Generate Quote',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
}
