import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCdjLZqNd0sCV_tZQLe6d_DeKH24ZIqLmU',
          appId: '1:585531291986:android:00e0d9defa1ffb9da2a28b',
          messagingSenderId: '585531291986',
          projectId: 'led-1-70768',
          databaseURL: 'https://led-1-70768-default-rtdb.firebaseio.com/'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Room Automation System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
