import 'package:flutter/material.dart';

class SmartHomeLightCard extends StatefulWidget {
  final String lightName;
  final Color lightColor;
  final bool isOn;

  const SmartHomeLightCard({
    Key? key,
    required this.lightName,
    required this.lightColor,
    this.isOn = false,
  }) : super(key: key);

  @override
  _SmartHomeLightCardState createState() => _SmartHomeLightCardState();
}

class _SmartHomeLightCardState extends State<SmartHomeLightCard> {
  late bool isOn;

  @override
  void initState() {
    super.initState();
    isOn = widget.isOn;
  }

  void toggleLight() {
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLight,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isOn ? widget.lightColor.withOpacity(0.8) : Colors.grey[300],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb,
                size: 40,
                color: isOn ? Colors.white : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                widget.lightName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isOn ? Colors.white : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 5),
              // Text(
              //   isOn ? 'ON' : 'OFF',
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.w600,
              //     color: isOn ? Colors.white : Colors.black45,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
