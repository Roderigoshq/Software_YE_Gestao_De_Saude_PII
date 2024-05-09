import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            CalendarWidget(), // Widget de calendário
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFC6D687),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Exit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late final ValueNotifier<List<DateTime>> selectedDates;

  @override
  void initState() {
    super.initState();
    selectedDates = ValueNotifier<List<DateTime>>([]);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      selectedDayPredicate: (day) => selectedDates.value.contains(day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (!selectedDates.value.contains(selectedDay)) {
            selectedDates.value = [selectedDay];
          } else {
            selectedDates.value = [];
          }
        });
      },
    );
  }

  @override
  void dispose() {
    selectedDates.dispose();
    super.dispose();
  }
}
