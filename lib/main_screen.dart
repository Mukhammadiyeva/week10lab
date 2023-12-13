import 'package:flutter/material.dart';
import 'db_helper.dart';

class MainScreen extends StatelessWidget {
  final int userId;

  MainScreen(this.userId);

  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: FutureBuilder<User?>(
            future: dbHelper.getUser(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return Text('No user data found.');
              } else {
                User? user = snapshot.data;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/your_image.png', // Adjust the path accordingly
                      width: 150.0,
                      height: 150.0,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome, ${user!.username}!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Phone: ${user.phone}'),
                    Text('Email: ${user.email}'),
                    Text('Address: ${user.address}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implement any action for the main screen button
                      },
                      child: Text('Main Screen Button'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
