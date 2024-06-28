import 'package:flutter/material.dart';
import 'package:people_frontend/model/person.dart';

class UserDetails extends StatelessWidget {
  final Person person;
  UserDetails({required this.person});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(person.name)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(person.imageUrl),
              ),
              SizedBox(height: 16),
              Text(
                'Name: ${person.name}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Date of Birth: ${person.dateOfBirth}',
                style: TextStyle(fontSize: 18),
              ),
              // Add more details here if needed
            ],
          ),
        ),
      ),
    );
  }
}