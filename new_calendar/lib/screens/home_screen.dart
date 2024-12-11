import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'schedule_screen.dart';
import 'menstrual_calendar_screen.dart';
import 'complaint_screen.dart';
import 'agenda_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MapScreen(),
    ScheduleScreen(),
    MenstrualCalendarScreen(),
    ComplaintScreen(),
    AgendaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela Principal')),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color.fromARGB(255, 7, 43, 71),
        selectedItemColor: const Color.fromARGB(255, 51, 104, 163),
        unselectedItemColor: const Color.fromARGB(255, 7, 43, 71),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendário Menstrual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Queixas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Agenda',
          ),
        ],
      ),
    );
  }
}
