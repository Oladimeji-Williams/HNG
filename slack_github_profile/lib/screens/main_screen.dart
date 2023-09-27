import 'package:flutter/material.dart';
import 'webview_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double fontSize = width * 0.05; // Dynamic font size based on screen width

    return Scaffold(
      backgroundColor:
          Colors.grey[200], // Setting a light grey background color
      appBar: AppBar(
        title: const Text('Slack Profile'),
        backgroundColor: Colors.teal, // Using a teal color for the AppBar
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.1), // 10% padding from both sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Oladimeji Williams', // Slack Name
                style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black87), // Adjusted font size
              ),
              SizedBox(height: height * 0.02), // Dynamic vertical spacing
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 3), // Shadow position
                      blurRadius: 5.0, // Shadow blur
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://ca.slack-edge.com/T05FFAA91JP-U05RAGFQYCA-06b6c3e635ed-192', // Slack profile picture URL
                    fit: BoxFit.cover,
                    width: width * 0.3, // Adjusting width dynamically
                    height: width *
                        0.3, // Keeping height same as width for a perfect circle
                  ),
                ),
              ),
              SizedBox(height: height * 0.02), // Dynamic vertical spacing
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal), // Adjust button color to match AppBar
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WebViewScreen()),
                  );
                },
                child: const Text('Open GitHub'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
