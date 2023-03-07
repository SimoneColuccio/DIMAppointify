import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/activity.dart';
import 'package:my_app/Data/appointment.dart';

import '../Data/openingTime.dart';
import '../Widgets/bottomMenu.dart';
import 'accountPage.dart';
import 'confirmAppointment.dart';

class BookAppointmentPage extends StatefulWidget {
  const BookAppointmentPage({super.key});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class BookAppointmentArguments{
  BookAppointmentArguments(this.appointment, this.operation);
  Appointment appointment;
  String operation;
}

class _BookAppointmentPageState extends State<BookAppointmentPage>{

  final dataController = TextEditingController();
  final dataFocusNode = FocusNode();
  final userController = TextEditingController();
  final userFocusNode = FocusNode();

  late String type;

  late Activity activity;
  late Appointment appointment;

  late double pressed;

  List<int> seq = [];

  String feedback = "";

  String? appointType;
  late DateTime date;
  List<int> hour = [];
  String user = "";

  bool modified = false;
  @override
  Widget build(BuildContext context) {

    var args = ModalRoute.of(context)!.settings.arguments as BookAppointmentArguments;
    final Appointment app = args.appointment;
    final Activity a = args.appointment.activity;
    final String t = args.operation;
    appointment = app;
    activity = a;
    type = t;
    for(var aa in allActivities) {
      if(aa.name == a.name && aa.description == a.description && aa.category == a.category && aa.dateOfAdding == a.dateOfAdding) {
        activity = aa;
      }
    }

    if(!modified) {
      if(args.appointment.user != "activity") {
        user = args.appointment.user;
        userController.text = args.appointment.user;
      }
      date = args.appointment.dateTime;
      if(activity.category != "Hotels and travels") {
        pressed = toDouble(args.appointment.dateTime.hour, args.appointment.dateTime.minute);
      } else {
        pressed = args.appointment.duration * 1.0;
      }
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
      if(activity.category == "Hotels and travels"){
        while (!checkAvailabilities(date)) {
          date = DateTime(date.year, date.month, date.day + 1);
          args.appointment.updateDate(date);
        }
      }
    }

    dataController.text = DateFormat('yyyy-MM-dd').format(date);

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.name),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                      selectableDayPredicate: activity.category == "Hotels and travels" ? checkAvailabilities : null,
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
                  int? x;
                  int? y;
                  if(activity.hours[getWeekDay(date)][2] != -1) {
                    x = getHour(activity.hours[day][2]);
                    y = getMinute(activity.hours[day][2]);
                  }

                  int ii = getHour(pressed);
                  int jj = getMinute(pressed);
                  if(activity.appointments.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: (pressed == -1) ? Row(
                            children: [
                              for (int z = 0; z < activity.appointments[day].length && i <= getHour(activity.hours[day][1]); z++, j = j + activity.duration, j>=60 ? (j = j-60) & (i++) : 0)
                                checkFuture(i,j) || !checkAvailabilities(DateTime(date.year, date.month, date.day, i, j)) ?
                                const SizedBox() :
                                OutlinedButton(
                                  onPressed: () => {
                                    seq = [0, z],
                                    modified = true,
                                    pressed = activity.toHour(day, 0, z),
                                    hour = [getHour(pressed), getMinute(pressed)],
                                    date = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      hour.first,
                                      hour.last,
                                    ),
                                    setNewState(() {}),
                                    setState(() {}),
                                  },
                                  child: printTime(i, j),
                                ),
                            ],
                          ) : Row(
                            children: [
                              for (int z = 0; z < activity.appointments[day].length && i <= getHour(activity.hours[day][1]); z++, j = j + activity.duration, j>=60 ? (j = j-60) & (i++) : 0)
                                !checkFuture(i,j) && checkAvailabilities(DateTime(date.year, date.month, date.day, i, j)) ?
                                  (ii != i || jj != j) ?
                                    OutlinedButton(
                                      onPressed: () => {
                                        seq = [0, z],
                                        modified = true,
                                        pressed = activity.toHour(day, 0, z),
                                        hour = [getHour(pressed), getMinute(pressed)],
                                        date = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          hour.first,
                                          hour.last,
                                        ),
                                        setNewState(() {}),
                                        setState(() {}),
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
                                      setState(() {});
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
                              for (int z = 0; z < activity.appointments[day].length && x! <= getHour(activity.hours[day][3]); z++, y = y + activity.duration, y>=60 ? (y = y-60) & (x++) : 0)
                                checkFuture(x,y!) || !checkAvailabilities(DateTime(date.year, date.month, date.day, x, y)) ?
                                  const SizedBox() :
                                  OutlinedButton(
                                    onPressed: () => {
                                      seq = [1, z],
                                      modified = true,
                                      pressed = activity.toHour(getWeekDay(date), 2, z),
                                      hour = [getHour(pressed), getMinute(pressed)],
                                      date = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        hour.first,
                                        hour.last,
                                      ),
                                      setNewState(() {}),
                                      setState(() {}),
                                    },
                                    child: printTime(x, y),
                                  ),
                            ],
                          ) : Row(
                            children: [
                              for (int z = 0; z < activity.appointments[getWeekDay(date)].length && x! <= getHour(activity.hours[day][3]); z++, y = y + activity.duration, y>=60 ? (y = y-60) & (x++) : 0)
                                !checkFuture(x,y!) && checkAvailabilities(DateTime(date.year, date.month, date.day, x, y)) ?
                                  (ii != x || jj != y) ?
                                    OutlinedButton(
                                      onPressed: () => {
                                        seq = [0, z],
                                        modified = true,
                                        pressed = activity.toHour(getWeekDay(date), 2, z),
                                        hour = [getHour(pressed), getMinute(pressed)],
                                        date = DateTime(
                                          date.year,
                                          date.month,
                                          date.day,
                                          hour.first,
                                          hour.last,
                                        ),
                                        setNewState(() {}),
                                        setState(() {}),
                                      },
                                      child: printTime(x, y),
                                    ) : ElevatedButton(
                                      onPressed: () {
                                        seq = [];
                                        modified = true;
                                        pressed = -1;
                                        hour = [];
                                        setNewState(() {});
                                        setState(() {});
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
              child: checkAvailabilities(date) ? Row(
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
                        while (!checkAvailabilities(date)) {
                          date = DateTime(date.year, date.month, date.day + 1);
                          args.appointment.updateDate(date);
                        }
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.add_circle_outline)
                  ),
                ],
              ) : const SizedBox(),
            ),
            Text(
              correctInput(),
              style: TextStyle(
                color: feedback == "CORRECT"
                  ? Colors.green
                  : Colors.red,
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
                      if(seq.isEmpty && activity.category == "Hotels and travels") {
                        seq = [pressed.toInt()];
                      }
                      if(appointType != "" && (isLoggedAsActivity || hour != []) && (!isLoggedAsActivity || user != "") && checkAvailabilities(date)) {
                        date = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        hour.isNotEmpty ? hour.first : 15,
                        hour.isNotEmpty ? hour.last : 0
                        );
                        Appointment a = args.appointment.editAppointment(
                          args.appointment.index,
                          user,
                          date,
                          appointType,
                          seq,
                          activity.category == "Hotels and travels" ? pressed.toInt() : activity.duration,
                          true,
                          type
                        );
                        Navigator.pushNamed(
                          context,
                          '/confirmation',
                          arguments: AppointmentArguments(a)
                        );
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

  String correctInput() {
    if(user.trim().isEmpty && !isLoggedAsUser) {
      feedback = "Insert a valid user";
      return feedback;
    }
    if(appointType == "") {
      feedback = "Select a service for your appointment";
      return feedback;
    }
    if(checkAvailabilities(date) || feedback == "AVAILABLE") {
      feedback = "CORRECT";
    }
    if(hour.isEmpty && activity.category != "Hotels and travels") {
      feedback = "Select an hour";
    } else {
      feedback = "CORRECT";
    }
    return feedback;
  }

  bool checkFuture(int i, int j) {
    return (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day &&
        (i == DateTime.now().hour && j <= DateTime.now().minute ||
            i < DateTime.now().hour));
  }

  bool checkAvailability(DateTime date) {

    List<Appointment> appointments = [];

    List<int> s = getSequentialCode(activity, date);
    if(s.isEmpty || s.first < 0 && activity.category != "Hotels and travels") {
      return false;
    }

    if(activity.appointments[getWeekDay(date)][0][0] == 0) {
      feedback = "Empty appointments for this day";
      return false;
    }

    for(var a in allAppointments) {
      if(a.activity.name == activity.name && a.activity.dateOfAdding == activity.dateOfAdding && a.activity.category == activity.category &&
          a.dateTime.year == date.year && a.dateTime.month == date.month && a.dateTime.day == date.day) {
        if(activity.category != "Hotels and travels") {
          if(a.dateTime.hour == date.hour && a.dateTime.minute == date.minute && a.index != appointment.index) {
            appointments.add(a);
          }
        } else {
          if(a.dateTime.hour == 15 && a.index != appointment.index) {
            appointments.add(a);
          }
        }
      }
    }
    if(activity.category != "Hotels and travels") {
      if(appointments.length >= activity.appointments[getWeekDay(date)][s.first][s.last]) {
        return false;
      }
    } else {
      //log("appointments already booked in this day ${appointments.length - increment}");
      if(appointments.length >= activity.appointments[getWeekDay(date)][0][0]) {
        feedback = "Full appointments for this day";
        return false;
      }
    }
    feedback = "AVAILABLE";
    return true;
  }

  bool checkAvailabilities(DateTime date) {
    bool r = true;
    if(activity.category == "Hotels and travels") {
      for(int i = 0; i < pressed; i++) {
        DateTime d = DateTime(date.year, date.month, date.day + i);
        r = r && checkAvailability(d);
        if(!r) {
          return false;
        }
      }
    } else {
      return checkAvailability(date);
    }

    return r;
  }

}
