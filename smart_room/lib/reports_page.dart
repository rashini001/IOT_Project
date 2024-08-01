import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:smart_room/home_page.dart';
import 'dart:async'; // Import for StreamSubscription

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int bulbOnCount = 0;
  int bulbOffCount = 0;
  int fanOnCount = 0;
  int fanOffCount = 0;
  int doorLockCount = 0;
  int doorUnlockCount = 0;
  late StreamSubscription bulbStatusSubscription;
  late StreamSubscription fanStatusSubscription;
  late StreamSubscription doorStatusSubscription;

  @override
  void initState() {
    super.initState();
    _fetchInitialCounts();
    _trackStatusChanges();
  }

  @override
  void dispose() {
    bulbStatusSubscription.cancel();
    fanStatusSubscription.cancel();
    doorStatusSubscription.cancel();
    super.dispose();
  }

  void _fetchInitialCounts() {
    String date = "2023-06-12"; // Replace with actual date fetching method

    _database.child('reports/$date/bulb/on_count').get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          bulbOnCount = snapshot.value as int;
        });
      }
    });

    _database.child('reports/$date/bulb/off_count').get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          bulbOffCount = snapshot.value as int;
        });
      }
    });

    _database.child('reports/$date/fan/on_count').get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          fanOnCount = snapshot.value as int;
        });
      }
    });

    _database.child('reports/$date/fan/off_count').get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          fanOffCount = snapshot.value as int;
        });
      }
    });

    _database.child('reports/$date/door/lock_count').get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          doorLockCount = snapshot.value as int;
        });
      }
    });

    _database.child('reports/$date/door/unlock_count').get().then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          doorUnlockCount = snapshot.value as int;
        });
      }
    });
  }

  void _trackStatusChanges() {
    String date = "2023-06-12"; // Replace with actual date fetching method

    bulbStatusSubscription =
        _database.child('bulb_STATUS').onValue.listen((event) {
      var value = event.snapshot.value;
      if (value == 1) {
        setState(() {
          bulbOnCount++;
        });
        _database.child('reports/$date/bulb/on_count').set(bulbOnCount);
      } else if (value == 0) {
        setState(() {
          bulbOffCount++;
        });
        _database.child('reports/$date/bulb/off_count').set(bulbOffCount);
      }
    });

    fanStatusSubscription =
        _database.child('fan_STATUS').onValue.listen((event) {
      var value = event.snapshot.value;
      if (value == "ON") {
        setState(() {
          fanOnCount++;
        });
        _database.child('reports/$date/fan/on_count').set(fanOnCount);
      } else if (value == "OFF") {
        setState(() {
          fanOffCount++;
        });
        _database.child('reports/$date/fan/off_count').set(fanOffCount);
      }
    });

    doorStatusSubscription =
        _database.child('door_STATUS').onValue.listen((event) {
      var value = event.snapshot.value;
      if (value == 1) {
        setState(() {
          doorLockCount++;
        });
        _database.child('reports/$date/door/lock_count').set(doorLockCount);
      } else if (value == 0) {
        setState(() {
          doorUnlockCount++;
        });
        _database.child('reports/$date/door/unlock_count').set(doorUnlockCount);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daily Report',
          style: TextStyle(fontSize: 28), // Set app bar title font size
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(
            255, 93, 91, 91), // Set app bar background color
        leading: IconButton(
          icon: const Icon(Icons.home, size: 32), // Set home icon size
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomePage()), // Replace HomePage() with your home page class constructor
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/door.jpg'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              color: Colors.grey.withOpacity(
                  0.7), // Set background color of the table to gray with some opacity
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Minimize the size of the column
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.grey[400]),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 8, 1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Count',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 31, 8, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                      _buildTableRow('Bulb On Count', bulbOnCount),
                      _buildTableRow('Bulb Off Count', bulbOffCount),
                      _buildTableRow('Fan On Count', fanOnCount),
                      _buildTableRow('Fan Off Count', fanOffCount),
                      _buildTableRow('Door Unlock Count', doorUnlockCount),
                      _buildTableRow('Door Lock Count', doorLockCount),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String status, int count) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            status,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            count.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
