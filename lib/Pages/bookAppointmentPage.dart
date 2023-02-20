import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/appointment.dart';

import '../Widgets/bottomMenu.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class BookAppointmentArguments{
  BookAppointmentArguments(this.activity, this.user);
  final Activity activity;
  final String user;
}

class _BookAppointmentPageState extends State<BookAppointmentPage>{

  final dataController = TextEditingController();
  final dataFocusNode = FocusNode();
  DateTime date = DateTime.now();
  List<int> hour = [];

  double pressed = -1;
  String? appointType = "";

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as BookAppointmentArguments;
    Activity a = args.activity;
    String user = args.user;

    Activity activity = a;
    for(var aa in allActivities) {
      if(aa.name == a.name && aa.description == a.description && aa.category == a.category && aa.dateOfAdding == a.dateOfAdding) {
        activity = aa;
      }
    }

    dataController.text = DateFormat('yyyy-MM-dd').format(date);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book a new appointment"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Desired service"),
            DropdownButtonFormField<String>(
              value: appointType,
              items: activity.appTypes.map((cat) => DropdownMenuItem<String>(
                value: cat,
                child: Text(cat, style: const TextStyle(fontSize: 15),
                ),
              )).toList(),
              onChanged: (cat) => setState(() => appointType = cat),
            ),
            const SizedBox(height: 50),
            const Text("Date"),
            TextField(
              controller: dataController,
              focusNode: dataFocusNode,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Date" //label text of field
              ),
              textAlign: TextAlign.left,
              keyboardType: TextInputType.datetime,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  date = pickedDate;
                  setState(() {
                    dataController.text = formattedDate; //set output date to TextField value.
                  });
                }
              },
            ),
            const SizedBox(height: 50),
            const Text("Hour"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StatefulBuilder(
                builder: (context, setNewState) {
                  if (pressed == -1) {
                    return Row(
                      children: [
                        for(int i = 8; i <= 20; i++)
                          for(int j = 0; j < 60; j = j + 30)
                            checkFuture(i,j) ?
                            const SizedBox(height: 0) :
                            TextButton(
                              onPressed: () => {
                                pressed = (i + 0.01 * j),
                                hour = [i, j],
                                setNewState(() {}),
                              },
                              child: printTime(i, j),
                            ),
                      ],
                    );
                  } else {
                    int ii = pressed.toInt();
                    int jj = ((pressed % 1) * 100).floor();
                    return Row(
                      children: [
                        for(int i = 8; i <= 20; i++)
                          for (int j = 0; j < 60; j = j + 30)
                            !checkFuture(i,j) ?
                              (ii != i || jj != j) ?
                                TextButton(
                                  onPressed: () => {
                                    pressed = (i + 0.01 * j),
                                    hour = [i, j],
                                    setNewState(() {}),
                                  },
                                  child: printTime(i, j),
                                )
                              : OutlinedButton(
                                  onPressed: () {
                                    pressed = -1;
                                    date = DateTime.now();
                                    hour = [];
                                    setNewState(() {});
                                  },
                                  child: printTime(ii, jj),
                                )
                            : const SizedBox(height: 0),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      pressed = -1;
                      appointType = "";
                      Navigator.pop(context);
                      //setState(() {});
                    }, child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if(appointType != "" && hour != []) {
                        date = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        hour.first,
                        hour.last
                        );
                        Appointment a = Appointment(user, activity, date, appointType!);
                        addAppointments(a);
                        Navigator.pop(context);
                      }

                      //setState(() {});
                    },
                    child: const Text("Confirm Appointment"),
                  ),
                )
              ],
            )
          ],

        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.red.withOpacity(.60),
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              Navigator.pushNamed(context, '/incoming');
              break;
            case 2:
              Navigator.pushNamed(context, '/past');
              break;
            case 3:
              Navigator.pushNamed(context, '/account');
              break;
          }
        },
        items: getBottomMenu(0)
      )
    );
  }

  Widget printTime(int i, int j) {
    if (i >= 10 && j >= 10) return Text("$i:$j");
    if (i < 10 && j >= 10) return Text("0$i:$j");
    if (i >= 10 && j < 10) return Text("$i:0$j");
    return Text("0$i:0$j");
  }

  bool checkFuture(int i, int j) {
    return (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day &&
        (i == DateTime.now().hour && j <= DateTime.now().minute ||
            i < DateTime.now().hour));
  }
}