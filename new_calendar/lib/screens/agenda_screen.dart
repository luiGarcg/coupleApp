import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const AgendaScreen());
}

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<DateTime, List<Map<String, String>>> events = {};
  DateTime selectedDay = DateTime.now();

  bool hasEvents(DateTime day) {
    return events.containsKey(DateTime(day.year, day.month, day.day)) &&
        events[DateTime(day.year, day.month, day.day)]!.isNotEmpty;
  }

  List<Map<String, String>>? getEventForDay(DateTime day) {
    return events[DateTime(day.year, day.month, day.day)];
  }

  void _showEventDialog(BuildContext context, DateTime selectedDate) {
    final titleController = TextEditingController();
    final observationController = TextEditingController();
    final whoController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    void addEvent() {
      final formattedTime =
          "${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}";
      setState(() {
        events.putIfAbsent(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day),
            () => []);
        events[DateTime(selectedDate.year, selectedDate.month, selectedDate.day)]!
            .add({
          'title': titleController.text,
          'time': formattedTime,
          'observation': observationController.text,
          'who': whoController.text,
        });
      });
    }

    void showNewDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Novo Compromisso"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Título"),
                  ),
                  TextField(
                    controller: observationController,
                    decoration: const InputDecoration(labelText: "Observação"),
                  ),
                  TextField(
                    controller: whoController,
                    decoration: const InputDecoration(labelText: "Quem"),
                  ),
                  ListTile(
                    title: Text("Horário: ${selectedTime.format(context)}"),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setState(() {
                          selectedTime = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () {
                  addEvent();
                  Navigator.of(context).pop();
                },
                child: const Text("Salvar"),
              ),
            ],
          );
        },
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicionar/Visualizar Anotações"),
          content: SingleChildScrollView(
            child: Column(
              children: getEventForDay(selectedDate)?.asMap().entries.map((entry) {
                    final index = entry.key;
                    final event = entry.value;
                    bool isExpanded = false;
                    return StatefulBuilder(
                      builder: (context, setInnerState) {
                        return ExpansionTile(
                          title: Text(event['title'] ?? ""),
                          subtitle: Text(event['time'] ?? ""),
                          children: [
                            ListTile(
                              title: Text("Observação: ${event['observation']}"),
                            ),
                            ListTile(
                              title: Text("Quem: ${event['who']}"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  events[DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                  )]!
                                      .removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Excluir"),
                            ),
                          ],
                          onExpansionChanged: (value) {
                            setInnerState(() {
                              isExpanded = value;
                            });
                          },
                        );
                      },
                    );
                  }).toList() ??
                  [
                    const Text("Sem compromissos."),
                  ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fechar"),
            ),
            ElevatedButton(
              onPressed: () => showNewDialog(),
              child: const Text("Adicionar Novo"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2025),
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.selectedDay = selectedDay;
              });
              _showEventDialog(context, selectedDay);
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 23, 87, 161),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Color.fromARGB(255, 250, 250, 250),
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (hasEvents(date)) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
