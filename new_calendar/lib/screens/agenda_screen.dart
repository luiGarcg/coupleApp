import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaScreen extends StatefulWidget {
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  TextEditingController _noteController = TextEditingController();

  Map<DateTime, String> _savedNotes = {};

  DateTime _selectedDay = DateTime.now();

  void _saveNote() {
    setState(() {
      _savedNotes[_selectedDay] = _noteController.text;
    });
    _noteController.clear();
    Navigator.of(context).pop();
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Anotação para ${_selectedDay.toLocal()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Adicionar Anotação',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Salvar Anotação'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getDayMarkers(DateTime day) {
    if (_savedNotes.containsKey(day)) {
      return [
        Positioned(
          bottom: 1,
          right: 1,
          child: Icon(
            Icons.circle,
            color: Colors.black,
            size: 8,
          ),
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agenda com Anotações')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 01, 01),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
                _showAddNoteDialog();
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              eventLoader: (day) {
                return _savedNotes.containsKey(day) ? ['Nota'] : [];
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  return Stack(
                    children: _getDayMarkers(date),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            if (_savedNotes.containsKey(_selectedDay))
              Row(
                children: [
                  Icon(Icons.circle, color: Colors.green, size: 12),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _savedNotes[_selectedDay]!,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
