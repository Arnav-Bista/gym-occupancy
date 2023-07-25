import 'package:flutter/material.dart';

class OccupancyScreen extends StatelessWidget {
  const OccupancyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Text("80%",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: 72,
            fontWeight: FontWeight.bold
          )
        ),
      )
    );
  }
}
