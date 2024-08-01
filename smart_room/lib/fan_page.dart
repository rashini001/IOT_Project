import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:async'; // Import the dart:async package for StreamSubscription

class FanPage extends StatefulWidget {
  const FanPage({super.key});

  @override
  _FanPageState createState() => _FanPageState();
}

class _FanPageState extends State<FanPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  double temperature = 0.0;
  bool fanStatus = false;
  late StreamSubscription _temperatureSubscription;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  @override
  void dispose() {
    _temperatureSubscription.cancel();
    super.dispose();
  }

  void _fetchStatus() {
    _temperatureSubscription =
        _database.child('fan_TEMP').onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        final temp = value as num; // Ensure the value is treated as a number
        setState(() {
          temperature = temp.toDouble();
          fanStatus = temperature >= 20; // Example threshold for fan on/off
        });
      }
    });
  }

  void _updateFirebase() {
    _database.child('fan_STATUS').set(fanStatus ? 'ON' : 'OFF');
    _database.child('fan_TEMP').set(temperature);
  }

  void _updateTemperature(double newTemp) {
    setState(() {
      temperature = newTemp;
      fanStatus = temperature >= 20; // Example threshold for fan on/off
    });
    _updateFirebase(); // Update Firebase fields
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fan',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color.fromARGB(232, 92, 90, 90),
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
            image: AssetImage("assets/images/fan.jpg"), // Background image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                radius: 100,
                lineWidth: 14,
                percent: temperature / 100, // Assuming max temperature is 100
                progressColor: const Color.fromARGB(224, 28, 28, 29),
                center: Text(
                  '${temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Fan Status: ${fanStatus ? 'ON' : 'OFF'}',
                style: const TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 35, 35, 36),
                ),
              ),
              const SizedBox(height: 25),
              Slider(
                value: temperature,
                min: 0,
                max: 100,
                divisions: 100,
                label: temperature.toStringAsFixed(1),
                activeColor: Colors.black, // Slider color changed to black
                onChanged: (newTemp) {
                  _updateTemperature(newTemp);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
