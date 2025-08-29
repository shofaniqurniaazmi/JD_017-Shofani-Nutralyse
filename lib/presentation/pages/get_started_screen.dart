import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nutralyse_jd/common/assets/assets.dart';

class GetStartedScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Hide the app bar
        child: AppBar(
          backgroundColor: Colors.transparent, // Make app bar transparent
          elevation: 0, // Remove app bar elevation
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              welcomeImage, // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          // Purple transparent container at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200, // Adjust the height as needed
              decoration: BoxDecoration(
                color: Color(0xFF670274)
                    .withOpacity(0.8), // Purple color with opacity
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), // Rounded top left corner
                  topRight: Radius.circular(30), // Rounded top right corner
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'NutriTrack',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Make information about the food you are going to eat!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => context.go('/login'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.white, // Update to backgroundColor
                          foregroundColor:
                          Color(0xFF670274), // Update to foregroundColor
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Color(0xFF670274),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
