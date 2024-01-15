import 'package:flutter/material.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/screens/details_screen.dart';
import 'package:gym_occupancy/features/occupancy_screen/presentation/screens/occupancy_screen.dart';
import 'package:gym_occupancy/features/user_settings/presentation/settings_screen.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {

  final _widgetOptions = const [OccupancyScreen(), DetailsScreen()];
  int index = 0;

  void _onItemTapped(int num) {
    setState(() {
      index = num;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Occupancy", style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          TextButton(
            child: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const SettingsScreen();
              }));
            },
          ),
        ],
      ),
      body: _widgetOptions[index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.percent),
            label: "Occupancy"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Details"
          ),
        ],
        currentIndex: index,
        onTap: _onItemTapped,
      ),
    );
  }
}
