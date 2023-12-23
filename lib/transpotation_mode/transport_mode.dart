import 'package:flutter/material.dart';

class TransportModePage extends StatefulWidget {
  const TransportModePage({super.key});

  @override
  State<TransportModePage> createState() => _TransportModePageState();
}

class _TransportModePageState extends State<TransportModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your transport'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Handle the back button press here
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
        elevation: 5.0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50.0),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Select your transport type',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              padding: const EdgeInsets.all(16.0),
              children: [
                GestureDetector(
                  child: buildButton('Bicycle', 'assets/images/cycle.png'),
                  onTap: () {

                  },
                ),
                GestureDetector(
                  child: buildButton('Bike', 'assets/images/bike.png'),
                  onTap: () {},
                ),
                GestureDetector(
                  child: buildButton('Car', 'assets/images/car.png'),
                  onTap: () {},
                ),
                GestureDetector(
                  child: buildButton('Van', 'assets/images/van.png'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText, String imagePath) {
    return ElevatedButton(
      onPressed: () {
        // Handle button press
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(150.0, 150.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Color(0xFF311B92),
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 80.0,
            height: 80.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            buttonText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
