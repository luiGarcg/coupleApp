import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(ScheduleScreen());
}

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HabitNow Clone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HabitListScreen(),
    );
  }
}

class HabitListScreen extends StatefulWidget {
  @override
  _HabitListScreenState createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<DateTime> days = [];
  int _currentIndex = 0; 
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _generateDays();
  }

  void _generateDays() {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime(2050, 12, 31);

    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(Duration(days: 1))) {
      days.add(date);
    }
  }

  void _moveToNextDay() {
    if (_currentIndex < days.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _moveToPreviousDay() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _addActivity() async {
    String title = '';
    List<bool> selectedDays = List.generate(7, (index) => false); 
    TimeOfDay selectedTime = TimeOfDay.now();


    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Atividade'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(labelText: 'Título'),
                  ),
                  SizedBox(height: 10),
                  Text('Escolha os dias:'),
                  SizedBox(height: 10),

                  Column(
                    children: List.generate(7, (index) {
                      List<String> daysOfWeek = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
                      return CheckboxListTile(
                        title: Text(daysOfWeek[index]),
                        value: selectedDays[index],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedDays[index] = value!;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  Text('Definir horário:'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (newTime != null) {
                        setState(() {
                          selectedTime = newTime;
                        });
                      }
                    },
                    child: Text('Selecionar Horário: ${selectedTime.format(context)}'),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {

                if (title.isNotEmpty && selectedDays.contains(true)) {
                  setState(() {
                    activities.add(Activity(title, selectedDays, selectedTime));
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }


  List<Activity> _getActivitiesForDay(DateTime day) {
    List<Activity> activitiesForDay = [];
    for (var activity in activities) {

      if (activity.selectedDays[day.weekday - 1]) {
        activitiesForDay.add(activity);
      }
    }

    activitiesForDay.sort((a, b) => a.selectedTime.hour.compareTo(b.selectedTime.hour));
    return activitiesForDay;
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDay = days[_currentIndex];
    List<Activity> activitiesForCurrentDay = _getActivitiesForDay(currentDay);

    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios"),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _moveToPreviousDay,
                ),
                Text(
                  DateFormat('EEE, d').format(days[_currentIndex]),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: _moveToNextDay,
                ),
              ],
            ),
          ),

          Container(
            height: 100, 
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                DateTime day = days[index];
                String dayOfWeek = DateFormat('EEE', 'en_US').format(day).toUpperCase();
                String dayOfMonth = DateFormat('d').format(day);
                bool isSelected = index == _currentIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index; 
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayOfWeek,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          dayOfMonth,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
  
          Expanded(
            child: activitiesForCurrentDay.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum hábito definido.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: activitiesForCurrentDay.length,
                    itemBuilder: (context, index) {
                      var activity = activitiesForCurrentDay[index];
                      return ListTile(
                        title: Text("${activity.title} - ${activity.selectedTime.format(context)}"),
                        leading: IconButton(
                          icon: Icon(
                            activity.checkboxState == CheckboxState.green
                                ? Icons.check_circle
                                : activity.checkboxState == CheckboxState.red
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                            color: activity.checkboxState == CheckboxState.green
                                ? Colors.green
                                : activity.checkboxState == CheckboxState.red
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              activity.toggleCheckboxState();
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class Activity {
  final String title;
  final List<bool> selectedDays;
  final TimeOfDay selectedTime;
  CheckboxState checkboxState;

  Activity(this.title, this.selectedDays, this.selectedTime)
      : checkboxState = CheckboxState.initial;

  void toggleCheckboxState() {
    if (checkboxState == CheckboxState.initial) {
      checkboxState = CheckboxState.green;
    } else if (checkboxState == CheckboxState.green) {
      checkboxState = CheckboxState.red;
    } else {
      checkboxState = CheckboxState.initial;
    }
  }
}

enum CheckboxState {
  initial,
  green,
  red,
}
