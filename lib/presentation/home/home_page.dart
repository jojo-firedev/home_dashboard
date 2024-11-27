import 'package:flutter/material.dart';
import 'package:home_dashboard/presentation/components/light_card.dart';
import 'package:home_dashboard/presentation/components/light_indicator.dart';
import 'package:home_dashboard/service/home_assistant_socket.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeAssistantAPI api = HomeAssistantAPI();
  bool isLightOn = false;

  @override
  void initState() {
    super.initState();
    api.connect().then((_) {
      api.subscribeToEntity('light.jonas_schreibtisch_strip', (newState) {
        setState(() {
          isLightOn = newState == 'on';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              api.connect().then((_) {
                api.subscribeToEntity('light.jonas_schreibtisch_strip',
                    (newState) {
                  setState(() {
                    isLightOn = newState == 'on';
                  });
                });
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LightIndicator(isLightOn: isLightOn),
            const SmartHomeLightCard(
              lightName: "Wohnzimmer Licht",
              lightColor: Colors.yellow,
              isOn: false,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/settings'),
        child: const Icon(Icons.settings),
      ),
    );
  }

  @override
  void dispose() {
    api.dispose();
    super.dispose();
  }
}
