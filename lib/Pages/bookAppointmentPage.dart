import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/appointment.dart';

import '../Data/openingTime.dart';
import '../Widgets/bottomMenu.dart';
import 'accountPage.dart';

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
  final userController = TextEditingController();
  final userFocusNode = FocusNode();

  late double pressed;

  List<int> seq = [];

  String? appointType;
  late DateTime date;
  List<int> hour = [];
  String user = "";

  bool modified = false;
  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context)!.settings.arguments as BookAppointmentArguments;
    final Activity a = args.appointment.activity;

    if(!modified) {
      date = args.appointment.dateTime;
      pressed = toDouble(args.appointment.dateTime.hour, args.appointment.dateTime.minute);
      appointType = args.appointment.appointType;
      if(args.appointment.appointType != "") {
        hour = [args.appointment.dateTime.hour, args.appointment.dateTime.minute];
      }
    }

    if(args.appointment.appointType == "" && !modified) {
      if(args.appointment.activity.category != "Hotels and travels") {
        pressed = -1;
      } else {
        pressed = 1;
      }
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
            isLoggedAsActivity ? const Text("User"): const SizedBox(),
            isLoggedAsActivity ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                controller: userController,
                focusNode: userFocusNode,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  user = userController.text;
                  setState(() {});
                },
              ),
            ): const SizedBox(),
            const Text("Desired service"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: DropdownButtonFormField<String>(
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
            ),
            activity.category != "Hotels and travels" ? const Text("Date") : const Text("Check-in date"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
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
            ),
            activity.category != "Hotels and travels" ? const Text("Hour") : const Text("Nights"),
            activity.category != "Hotels and travels" ? Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: StatefulBuilder(
                builder: (context, setNewState) {
                  int day = getWeekDay(date);
                  int i = getHour(activity.hours[day][0]);
                  int j = getMinute(activity.hours[day][0]);
                  int x = getHour(activity.hours[day][1]);
                  int y = getMinute(activity.hours[day][1]);
                  int ii = getHour(pressed);
                  int jj = getMinute(pressed);
                  log(activity.appointments.toString());
                  if(activity.appointments.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: (pressed == -1) ? Row(
                            children: [
                              for (int z = 0; z < activity.appointments[day].length && i <= getHour(activity.hours[day][1]); z++, j = j + activity.duration, j>=60 ? (j = j-60) & (i++) : 0)
                                checkFuture(i,j) || !checkAvailability(activity, date, [i, j]) ?
                                const SizedBox() :
                                OutlinedButton(
                                  onPressed: () => {
                                    seq = [0, z],
                                    modified = true,
                                    pressed = activity.toHour(day, 0, z),
                                    hour = [getHour(pressed), getMinute(pressed)],
                                    setNewState(() {}),
                                  },
                                  child: printTime(i, j),
                                ),
                            ],
                          ) : Row(
                            children: [
                              for (int z = 0; z < activity.appointments[day].length && i <= getHour(activity.hours[day][1]); z++, j = j + activity.duration, j>=60 ? (j = j-60) & (i++) : 0)
                                !checkFuture(i,j) && checkAvailability(activity, date, [i, j]) ?
                                  (ii != i || jj != j) ?
                                    OutlinedButton(
                                      onPressed: () => {
                                        seq = [0, z],
                                        modified = true,
                                        pressed = activity.toHour(day, 0, z),
                                        log(pressed.toString()),
                                        hour = [getHour(pressed), getMinute(pressed)],
                                        log(hour.toString()),
                                        setNewState(() {}),
                                      },
                                      child: printTime(i, j),
                                    )
                                  : ElevatedButton(
                                    onPressed: () {
                                      seq = [];
                                      modified = true;
                                      pressed = -1;
                                      hour = [];
                                      setNewState(() {});
                                    },
                                    child: printTime(ii, jj),
                                  )
                                : const SizedBox(),
                            ],
                          )
                        ),
                        activity.hours[getWeekDay(date)][2] != -1 ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: (pressed == -1) ? Row(
                            children: [
                              for (int z = 0; z < activity.appointments[day].length && x <= getHour(activity.hours[day][3]); z++, y = y + activity.duration, y>=60 ? (y = y-60) & (x++) : 0)
                                checkFuture(x,y) || !checkAvailability(activity, date, [i, j]) ?
                                  const SizedBox() :
                                  OutlinedButton(
                                    onPressed: () => {
                                      seq = [1, z],
                                      log(seq.toString()),
                                      modified = true,
                                      pressed = activity.toHour(getWeekDay(date), 2, z),
                                      log(pressed.toString()),
                                      hour = [getHour(pressed), getMinute(pressed)],
                                      log(hour.toString()),
                                      setNewState(() {}),
                                    },
                                    child: printTime(x, y),
                                  ),
                            ],
                          ) : Row(
                            children: [
                              for (int z = 0; z < activity.appointments[getWeekDay(date)].length && x <= getHour(activity.hours[day][3]); z++, y = y + activity.duration, y>=60 ? (y = y-60) & (x++) : 0)
                                !checkFuture(x,y) && checkAvailability(activity, date, [i, j]) ?
                                  (ii != x || jj != y) ?
                                    OutlinedButton(
                                      onPressed: () => {
                                        seq = [0, z],
                                        modified = true,
                                        pressed = activity.toHour(getWeekDay(date), 2, z),
                                        hour = [getHour(pressed), getMinute(pressed)],
                                        setNewState(() {}),
                                      },
                                      child: printTime(x, y),
                                    ) : ElevatedButton(
                                      onPressed: () {
                                        seq = [];
                                        modified = true;
                                        pressed = -1;
                                        hour = [];
                                        setNewState(() {});
                                      },
                                      child: printTime(ii, jj),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ) : const SizedBox(),
                      ],
                  );
                  } else {
                    return const SizedBox();
                  }
                }
              ),
            ) : Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: checkAvailability(activity, date, hour) ? Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if(pressed > 1) {
                        pressed = pressed - 1;
                        modified = true;
                        seq = [pressed.toInt()];
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.remove_circle_outline)
                  ),
                  SizedBox(
                    width: 30,
                    child: Center(
                      child: Text(
                        pressed.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    )
                  ),
                  IconButton(
                    onPressed: () {
                      if(pressed < 10) {
                        pressed = pressed + 1;
                        modified = true;
                        seq = [pressed.toInt()];
                        log(pressed.toString());
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.add_circle_outline)
                  ),
                ],
              ) : const Text("No available appointments for the selected date",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
            ),
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
                      log(user.toString());
                      log(date.toString());
                      log(hour.toString());
                      log(seq.toString());
                      if(appointType != "" && (isLoggedAsActivity || hour != []) && (!isLoggedAsActivity || user != "") && checkAvailability(activity, date, hour)) {
                        date = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        hour.isNotEmpty ? hour.first : 15,
                        hour.isNotEmpty ? hour.last : 0
                        );
                        args.appointment.editAppointment(
                          user,
                          date,
                          appointType,
                          seq,
                          activity.category == "Hotels and travels" ? pressed.toInt() : activity.duration,
                          true
                        );
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
              if(args.appointment.appointType == "") {
                deleteAppointment(args.appointment);
              }
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              if(args.appointment.appointType == "") {
                deleteAppointment(args.appointment);
              }
              Navigator.pushNamed(context, '/incoming');
              break;
            case 2:
              if(args.appointment.appointType == "") {
                deleteAppointment(args.appointment);
              }
              Navigator.pushNamed(context, '/past');
              break;
            case 3:
              if(args.appointment.appointType == "") {
                deleteAppointment(args.appointment);
              }
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

  bool checkAvailability(Activity activity, DateTime date, List<int> hour) {
    List<Appointment> appointments = [];

    for(var a in allAppointments) {
      if(a.activity.name == activity.name && a.activity.dateOfAdding == activity.dateOfAdding && a.activity.category == activity.category &&
          a.dateTime.year == date.year && a.dateTime.month == date.month && a.dateTime.day == date.day) {
        if(hour.isNotEmpty) {
          if(a.dateTime.hour == hour.first && a.dateTime.minute == hour.last) {
            appointments.add(a);
          }
        } else {
          appointments.add(a);
        }
      }
    }

    if(appointments.length >= activity.concurrentAppointments) {
      return false;
    }
    return true;
  }

}
