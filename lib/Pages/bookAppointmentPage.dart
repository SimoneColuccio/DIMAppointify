import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Pages/activityManagerPage.dart';

import '../Widgets/bottomMenu.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class BookAppointmentArguments{
  BookAppointmentArguments(this.appointment);
  Appointment appointment;
}

class _BookAppointmentPageState extends State<BookAppointmentPage>{

  final dataController = TextEditingController();
  final dataFocusNode = FocusNode();

  late double pressed;

  String? appointType;
  late DateTime date;
  List<int> hour = [];

  bool modified = false;

  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context)!.settings.arguments as BookAppointmentArguments;
    final Activity a = args.appointment.activity;

    if(!modified) {
      date = args.appointment.dateTime;
      pressed = (args.appointment.dateTime.hour + 0.01 * args.appointment.dateTime.minute);
      appointType = args.appointment.appointType;
      if(args.appointment.appointType != "") {
        hour = [args.appointment.dateTime.hour, args.appointment.dateTime.minute];
      }
    }

    if(args.appointment.appointType == "" && !modified) {
      pressed = -1;
      appointType = args.appointment.appointType;
      date = args.appointment.dateTime;
    }

    Activity activity = a;
    for(var aa in allActivities) {
      if(aa.name == a.name && aa.description == a.description && aa.category == a.category && aa.dateOfAdding == a.dateOfAdding) {
        activity = aa;
      }
    }

    dataController.text = DateFormat('yyyy-MM-dd').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.name),
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
              onChanged: (cat) {
                modified = true;
                setState(() => appointType = cat);
              },
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
                modified = true;
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  date = pickedDate;
                  setState(() {
                    dataController.text = formattedDate; //set output date to TextField value.
                  });
                }
                if(pressed != -1){
                    if (checkFuture(hour.first, hour.last)) {
                      pressed = -1;
                      hour = [];
                    }
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
                    int day = getWeekDay(date);
                    return Row(
                      children: [
                        for(int i = getHour(activity.hours[day][0]); i <= getHour(activity.hours[day][1] - 0.01 * activity.duration); i++)
                          for (int j = (getMinute(activity.hours[day][0]) > 30 && i != getHour(activity.hours[day][0])) ? getMinute(activity.hours[day][0]) - 30 : getMinute(activity.hours[day][0]); j < getMinute(activity.hours[day][1] - 0.01 * activity.duration) && j < 60; j = j + 30)
                            checkFuture(i,j) ?
                            const SizedBox(height: 0) :
                            OutlinedButton(
                              onPressed: () => {
                                modified = true,
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
                    int day = getWeekDay(date);
                    return Row(
                      children: [
                        for(int i = getHour(activity.hours[day][0]); i <= getHour(activity.hours[day][1] - 0.01 * activity.duration); i++)
                          for (int j = (getMinute(activity.hours[day][0]) > 30 && i != getHour(activity.hours[day][0])) ? getMinute(activity.hours[day][0]) - 30 : getMinute(activity.hours[day][0]); j < getMinute(activity.hours[day][1] - 0.01 * activity.duration); j = j + 30)
                            !checkFuture(i,j) ?
                              (ii != i || jj != j) ?
                                OutlinedButton(
                                  onPressed: () => {
                                    modified = true,
                                    pressed = (i + 0.01 * j),
                                    hour = [i, j],
                                    setNewState(() {}),
                                  },
                                  child: printTime(i, j),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    modified = true;
                                    pressed = -1;
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
                      if(args.appointment.appointType == "") {
                        deleteAppointment(args.appointment);
                      }
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
                        args.appointment.editAppointment(date, appointType);
                        Navigator.pushNamed(context, '/incoming');
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

  bool checkFuture(int i, int j) {
    return (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day &&
        (i == DateTime.now().hour && j <= DateTime.now().minute ||
            i < DateTime.now().hour));
  }

  int getWeekDay(DateTime date) {
    return date.weekday - 1;
  }

}

Widget printTime(int i, int j) {
  if (i >= 10 && j >= 10) return Text("$i:$j");
  if (i < 10 && j >= 10) return Text("0$i:$j");
  if (i >= 10 && j < 10) return Text("$i:0$j");
  return Text("0$i:0$j");
}