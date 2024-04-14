import 'package:flutter/material.dart';
import 'package:home_dashboard/globals.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: StreamBuilder(
            stream: Globals.channel!.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/settings'),
        child: const Icon(Icons.settings),
      ),
    );
  }
}
