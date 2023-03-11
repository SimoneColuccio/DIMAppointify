import 'dart:developer';

import 'package:my_app/Data/openingTime.dart';

import '../Pages/accountPage.dart';
import '../Pages/incomingAppointmentsPage.dart';
import '../Pages/pastAppointmentsPage.dart';
import 'activity.dart';

class Appointment {
  int index;
  String user;
  final Activity activity;
  int sequentialNumber;
  DateTime dateTime;
  String appointType;
  int voted = -1;
  bool userGoogleCalendar = false;
  bool actGoogleCalendar = false;
  int duration;
  bool toShow = true;
  int people = 1;
  String message = "";

  Appointment(this.index, this.user, this.activity, this.dateTime, this.appointType, this.sequentialNumber, this.duration);

  void addToCalendar(bool user) {
    if(user) {
      userGoogleCalendar = true;
    } else {
      actGoogleCalendar = true;
    }
  }

  void updateDate(DateTime date) {
    dateTime = date;
  }

  Appointment editAppointment(appIndex, user, dateTime, appointType, int seq, int duration, bool toShow, String type, int people, String message) {
    if(user != "") {
      this.user = user;
    }
    this.dateTime = dateTime;
    this.appointType = appointType;
    this.duration = duration;
    this.toShow = toShow;
    this.people = people;
    this.message = message;

    Appointment ret = this;

    List<int> del = [];
    if(activity.category == "Hotels and travels") {
      if(type == "EDIT") {
        for(int k = 0; k < allAppointments.length; k++) {
          if(allAppointments[k].index == appIndex && !allAppointments[k].toShow) {
            del.add(k);
          }
        }
        while(del.isNotEmpty) {
          allAppointments.remove(allAppointments[del.last]);
          log("Appointment deleted");
          del.remove(del.last);
        }
      }
      if(seq > 1) {
        Appointment a = createAppointment(appIndex, user, activity);
        a.editAppointment(appIndex, user, DateTime(dateTime.year, dateTime.month, dateTime.day + 1, 15, 0), appointType, seq - 1, duration, false, "CREATE", people, message);
      }
    }

    log("Appointment edited");
    checkDates();

    return ret;
  }
}

int appointmentIndex = 0;
List<Appointment> allAppointments = [];

Appointment createAppointment(appIndex, user, activity) {
  Appointment a = Appointment(appIndex, user, activity, DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, getHour(activity.hours[getWeekDay(DateTime.now())][0]), getMinute(activity.hours[getWeekDay(DateTime.now())][0])), "", 0, 0);
  log(a.dateTime.toString());
  allAppointments.add(a);
  checkDates();
  log("Appointment created");
  return a;
}

void deleteAppointment (Appointment appointment) {
  if(!appointment.toShow && appointment.activity.category == "Hotels and travels") {
    int d = appointment.duration;
    DateTime dateTime = DateTime(
      appointment.dateTime.year,
      appointment.dateTime.month,
      appointment.dateTime.day - d + 1,
    );

    for(int i = 0; i < d - 1; i ++) {
      for(var a in allAppointments) {
        if(a.activity.name == appointment.activity.name && a.user == appointment.user && a.appointType == appointment.appointType &&
          a.dateTime.day == dateTime.day + i) {
          a.duration = a.duration - 1;
        }
      }
    }
  } else if(appointment.activity.category == "Hotels and travels") {
    int d = appointment.duration;
    for(int i = 1; i <= d - 1; i ++) {
      for(int x = 0; x < allAppointments.length; x++) {
        if(allAppointments[x].activity.name == appointment.activity.name && allAppointments[x].user == appointment.user && allAppointments[x].appointType == appointment.appointType &&
            allAppointments[x].dateTime.day == appointment.dateTime.day + i) {
          allAppointments.remove(allAppointments[x]);
        }
      }
    }
  }
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

List<int> getSequentialCode(Activity activity, DateTime date) {

  int weekDay = getWeekDay(date);

  int mOpHour = getHour(activity.hours[weekDay][0]);
  int mOpMins = getMinute(activity.hours[weekDay][0]);

  if(activity.continued[weekDay]) {
    int timeTot = (date.hour - mOpHour) * 60 + (date.minute - mOpMins);
    int s = timeTot ~/ activity.duration;

    return [s, 0];
  } else {
    int aOpHour = getHour(activity.hours[weekDay][2]);
    int aOpMins = getMinute(activity.hours[weekDay][2]);

    int mTimeTot = (date.hour - mOpHour) * 60 + (date.minute - mOpMins);
    int aTimeTot = (date.hour - aOpHour) * 60 + (date.minute - aOpMins);

    int sm = mTimeTot ~/ activity.duration;
    int sa = aTimeTot ~/ activity.duration;

    int mOp = mOpHour * 60 + mOpMins;

    int mSeq = mOp + sm * activity.duration;

    int mSeqHour = (mSeq / 60).floor();
    int mSeqMins = mSeq - mSeqHour * 60;

    if(mSeqHour == date.hour && mSeqMins == date.minute && sm < activity.appointments[weekDay].length && sm >= 0) {
      return [sm, 0];
    } else if(sa >= 0) {
      return [sa, 1];
    } else {
      return [];
    }

  }

}