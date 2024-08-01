import 'package:flutter/material.dart';
import 'lights_page.dart';
import 'fan_page.dart';
import 'door_page.dart';
import 'reports_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Room Automation System',
          style: TextStyle(
            fontSize: 28, // Set app bar font size
          ),
        ),
        backgroundColor: const Color.fromARGB(
            54, 49, 50, 52), // Set app bar background color
        leading: IconButton(
          icon: const Icon(Icons.home, size: 32), // Set home icon size
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Smart Room',
                  style: TextStyle(
                    fontSize: 36,
                    fontStyle:
                        FontStyle.italic, // Set title font style to italic
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(222, 237, 234, 234), // Set text color
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LightsPage()),
                        );
                      },
                      label: 'Lights',
                      color: const Color.fromARGB(
                          229, 131, 129, 129), // Set button color
                      width: 180, // Set button width
                    ),
                    _buildMenuButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FanPage()),
                        );
                      },
                      label: 'Fan',
                      color: const Color.fromARGB(
                          229, 131, 129, 129), // Set button color
                      width: 180, // Set button width
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DoorPage()),
                        );
                      },
                      label: 'Door',
                      color: const Color.fromARGB(
                          229, 131, 129, 129), // Set button color
                      width: 180, // Set button width
                    ),
                    _buildMenuButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportsPage()),
                        );
                      },
                      label: 'Reports',
                      color: const Color.fromARGB(
                          229, 131, 129, 129), // Set button color
                      width: 180, // Set button width
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
    double width = 150, // Default button width
  }) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Set button border radius
          ),
          backgroundColor: color, // Set button background color
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 20, // Set button text font size
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(174, 210, 216, 216), // Set button text color
          ),
        ),
      ),
    );
  }
}
