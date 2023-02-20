import 'dart:developer';

import 'activity.dart';

class Appointment {
  final String user;
  final Activity activity;
  final DateTime dateTime;
  final String appointType;
  int voted = -1;

  Appointment(this.user, this.activity, this.dateTime, this.appointType);
}

List<Appointment> allAppointments = [
  Appointment(
    "user1",
    Activity(
      allActivities[0].name,
      allActivities[0].description,
      allActivities[0].category,
      allActivities[0].position,
      allActivities[0].dateOfAdding,
      allActivities[0].appTypes,
    ),
    DateTime(DateTime.now().year, 02, 01, 23, 00),
    allActivities[0].appTypes.last
  ),
  Appointment(
      "user2",
      Activity(
        allActivities[0].name,
        allActivities[0].description,
        allActivities[0].category,
        allActivities[0].position,
        allActivities[0].dateOfAdding,
        allActivities[0].appTypes,
      ),
      DateTime.now(),
      allActivities[0].appTypes.last,
  ),
];

void addAppointments(Appointment value) {
  log(value.dateTime.year.toString());
  log(value.dateTime.month.toString());
  log(value.dateTime.day.toString());
  log(value.dateTime.hour.toString());
  log(value.dateTime.minute.toString());
  allAppointments.add(value);
}