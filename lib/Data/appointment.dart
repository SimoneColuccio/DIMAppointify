import 'dart:developer';

import 'package:my_app/Data/openingTime.dart';

import '../Pages/accountPage.dart';
import '../Pages/incomingAppointmentsPage.dart';
import '../Pages/pastAppointmentsPage.dart';
import 'activity.dart';

class Appointment {
  final String user;
  final Activity activity;
  int sequentialNumber;
  DateTime dateTime;
  String appointType;
  int voted = -1;
  bool userGoogleCalendar = false;
  bool actGoogleCalendar = false;

  Appointment(this.user, this.activity, this.dateTime, this.appointType, this.sequentialNumber);

  void addToCalendar(bool user) {
    if(user) {
      userGoogleCalendar = true;
    } else {
      actGoogleCalendar = true;
    }
  }

  void editAppointment(dateTime, appointType, List<int> seq) {
    this.dateTime = dateTime;
    this.appointType = appointType;
    activity.appointments[getWeekDay(dateTime)][seq.last][seq.first] = activity.appointments[getWeekDay(dateTime)][seq.last][seq.first] - 1;
    log("Appointment edited");
    log(activity.appointments.toString());
    checkDates();
  }
}

List<Appointment> allAppointments = [
  Appointment(
    "user1",
    Activity(
      allActivities[0].name,
      allActivities[0].category,
      allActivities[0].position,
      allActivities[0].dateOfAdding,
      allActivities[0].appTypes,
      allActivities[0].duration,
      allActivities[0].concurrentAppointments,
      allActivities[0].hours,
      allActivities[0].continued,
      allActivities[0].image,
    ),
    DateTime(DateTime.now().year, 02, 01, 11, 00),
    allActivities[0].appTypes.last,
    0
  ),
  Appointment(
    "user2",
    Activity(
      allActivities[0].name,
      allActivities[0].category,
      allActivities[0].position,
      allActivities[0].dateOfAdding,
      allActivities[0].appTypes,
      allActivities[0].duration,
      allActivities[0].concurrentAppointments,
      allActivities[0].hours,
      allActivities[0].continued,
      allActivities[0].image,
    ),
  DateTime(DateTime.now().year, 03, 01, 11, 00),
    allActivities[0].appTypes.last,
      0
  ),
];


Appointment createAppointment(user, activity) {
  Appointment a = Appointment(user, activity, DateTime.now(), "", 0);
  allAppointments.add(a);
  checkDates();
  log("Appointment created");
  return a;
}

void deleteAppointment (Appointment appointment) {
  allAppointments.remove(appointment);
  log("Appointment discarded");
}

void checkDates() {
  incomingAppointments = [];
  appointments = [];

  for(int i = 0; i < allAppointments.length; i++) {
    if ((allAppointments[i].user.toLowerCase() == user.toLowerCase() || user == "activity") &&
        !incomingAppointments.contains(allAppointments[i]) &&
        isTodayOrTomorrow(i)) {
      incomingAppointments.add(allAppointments[i]);
    }
  }

  for(int i = 0; i < allAppointments.length; i++) {
    if ((allAppointments[i].user.toLowerCase() == user.toLowerCase() || user == "activity") &&
        !appointments.contains(allAppointments[i]) &&
        !isTodayOrTomorrow(i) && isFuture(i)) {
      appointments.add(allAppointments[i]);
    }
  }

  for(int i = 0; i < allAppointments.length; i++) {
    if ((isLoggedAsUser && allAppointments[i].user.toLowerCase() == user.toLowerCase() || isLoggedAsActivity && user == "activity") &&
        !pastAppointments.contains(allAppointments[i]) &&
        !incomingAppointments.contains(allAppointments[i]) &&
        !appointments.contains(allAppointments[i])) {
      pastAppointments.add(allAppointments[i]);
    }
  }

}

bool isTodayOrTomorrow (int i) {

  var months30 = [1, 3, 5, 7, 8, 10];
  var months31 = [4, 6, 9, 11];

  //today
  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      allAppointments[i].dateTime.month == DateTime.now().month &&
      allAppointments[i].dateTime.day == DateTime.now().day &&
      (allAppointments[i].dateTime.hour >= DateTime.now().hour ||
          allAppointments[i].dateTime.hour == DateTime.now().hour &&
              allAppointments[i].dateTime.minute >= DateTime.now().minute)) {
    return true;
  }

  //easy tomorrow
  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      allAppointments[i].dateTime.month == DateTime.now().month &&
      allAppointments[i].dateTime.day == DateTime.now().day + 1) {
    return true;
  }

  //today is 31 and tomorrow is 1
  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      months31.contains(DateTime.now().month) && DateTime.now().day == 31 &&
      allAppointments[i].dateTime.month == DateTime.now().month + 1 &&
      allAppointments[i].dateTime.day == 1) {
    return true;
  }

  //today is 30 and tomorrow is 1
  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      months30.contains(DateTime.now().month) && DateTime.now().day == 30 &&
      allAppointments[i].dateTime.month == DateTime.now().month + 1 &&
      allAppointments[i].dateTime.day == 1) {
    return true;
  }

  //today is 28/29 and tomorrow is 1
  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      (DateTime.now().month == 2 && DateTime.now().day == 28 && DateTime.now().year % 4 != 0 ||
          DateTime.now().month == 2 && DateTime.now().day == 29 && DateTime.now().year % 4 == 0) &&
      allAppointments[i].dateTime.month == DateTime.now().month + 1 &&
      allAppointments[i].dateTime.day == 1) {
    return true;
  }

  //today is dec 31th and tomorrow is jan 1st
  if(allAppointments[i].dateTime.year == DateTime.now().year + 1 &&
      DateTime.now().month == 12 && DateTime.now().day == 31 &&
      allAppointments[i].dateTime.month == 1 && allAppointments[i].dateTime.day == 1) {
    return true;
  }

  return false;
}

bool isFuture(int i) {
  //Appointment next year
  if (allAppointments[i].dateTime.year > DateTime.now().year) {
    return true;
  }

  //Appointment next month
  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      allAppointments[i].dateTime.month > DateTime.now().month) {
    return true;
  }

  if (allAppointments[i].dateTime.year == DateTime.now().year &&
      allAppointments[i].dateTime.month == DateTime.now().month &&
      allAppointments[i].dateTime.day > DateTime.now().day + 1) {
    return true;
  }

  return false;
}