import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DoorPage extends StatefulWidget {
  const DoorPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DoorPageState createState() => _DoorPageState();
}

class _DoorPageState extends State<DoorPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool doorStatus = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  void _fetchStatus() {
    _database.child('door_STATUS').onValue.listen((event) {
      final bool status =
          event.snapshot.value != null ? event.snapshot.value == 1 : false;
      setState(() {
        doorStatus = status;
      });
    });
  }

  void _updateStatus(int status) {
    _database.child('door_STATUS').set(status);
    setState(() {
      doorStatus = status == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Door',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(232, 128, 87, 59),
        leading: IconButton(
          icon: const Icon(Icons.home, size: 36),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/report.jpg"), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.door_front_door,
                size: 100,
                color: doorStatus
                    ? const Color.fromARGB(238, 235, 234, 232)
                    : const Color.fromARGB(255, 85, 79, 80),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateStatus(0);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color.fromARGB(255, 13, 13, 13),
                    ),
                    child: const Text(
                      'Lock',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateStatus(1);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color.fromARGB(255, 41, 39, 39),
                    ),
                    child: const Text(
                      'Unlock',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
