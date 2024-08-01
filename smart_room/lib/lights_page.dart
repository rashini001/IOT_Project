import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class LightsPage extends StatefulWidget {
  const LightsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LightsPageState createState() => _LightsPageState();
}

class _LightsPageState extends State<LightsPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool bulbStatus = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  void _fetchStatus() {
    _database.child('bulb_STATUS').onValue.listen((event) {
      if (!_isUpdating) {
        final bool status =
            event.snapshot.value != null ? event.snapshot.value == 1 : false;
        setState(() {
          bulbStatus = status;
        });
      }
    });
  }

  void _updateStatus(int status) {
    setState(() {
      _isUpdating = true;
      bulbStatus = status == 1;
    });

    _database.child('bulb_STATUS').set(status).then((_) {
      setState(() {
        _isUpdating = false;
      });
    }).catchError((error) {
      setState(() {
        _isUpdating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lights System',
          style: TextStyle(fontSize: 28), // Set app bar title font size
        ),
        backgroundColor: const Color.fromARGB(
            255, 54, 49, 50), // Set app bar background color
        leading: IconButton(
          icon: const Icon(Icons.home, size: 36), // Set home icon size
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/light.png"), // Path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              size: 150, // Set icon size
              color: bulbStatus
                  ? const Color.fromARGB(238, 235, 234, 232)
                  : const Color.fromARGB(255, 85, 79,
                      80), // Change bulb icon color based on status
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateStatus(1);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50), // Set minimum button size
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24), // Set button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Set button border radius
                    ),
                    backgroundColor: const Color.fromARGB(
                        255, 55, 56, 56), // Set on button color
                  ),
                  child: const Text(
                    'Light On',
                    style:
                        TextStyle(color: Colors.white), // Set button text color
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateStatus(0);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50), // Set minimum button size
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24), // Set button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Set button border radius
                    ),
                    backgroundColor: const Color.fromARGB(
                        255, 32, 32, 32), // Set off button color
                  ),
                  child: const Text(
                    'Light Off',
                    style:
                        TextStyle(color: Colors.white), // Set button text color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
