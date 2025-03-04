import 'package:flutter/material.dart';

void createChallengDialogBox(BuildContext context) {
  final emailController = TextEditingController();
  final durationController = TextEditingController();
  final distanceController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: 'Duration',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: distanceController,
                decoration: InputDecoration(
                  labelText: 'Distance',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Submit'),
            onPressed: () {
              // Handle the submit action here
              String email = emailController.text;
              String duration = durationController.text;
              String distance = distanceController.text;

              // Print or use the values as needed
              print('Email: $email, Duration: $duration, Distance: $distance');

              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
