
import 'dart:developer';
import 'dart:io';

import 'package:flutter_geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Data/openingTime.dart';
import 'package:my_app/Pages/incomingAppointmentsPage.dart';
import 'package:my_app/Pages/pastAppointmentsPage.dart';

class Activity {
  int index;
  String name;
  String category;
  String position;
  DateTime dateOfAdding;
  int duration;
  int concurrentAppointments;
  List<List<double>> hours;
  List<bool> continued;
  File? image;
  double? lat;
  double? lon;

  String description = "";
  List<String> appTypes;
  double rating = 0.0;
  int votes = 0;
  List<List<List<int>>> appointments = [];

  Activity(
    this.index,
    this.name,
    this.category,
    this.position,
    this.dateOfAdding,
    this.appTypes,
    this.duration,
    this.concurrentAppointments,
    this.hours,
    this.continued,
    this.image,
  ) {
    getAddress();
  }


  void voteActivity (int vote) {
    double r = rating * votes;
    r = r + vote;
    votes = votes + 1;
    rating = r / votes;
  }

  Future<void> editActivity(name, category, description, appTypes, position, duration, concurrentAppointments, hours, continued, XFile? image) async {
    this.name = name;
    this.category = category;
    this.description = description;
    this.appTypes = appTypes;
    this.position = position;
    this.duration = duration;
    this.concurrentAppointments = concurrentAppointments;
    this.hours = hours;
    this.continued = continued;
    this.position = position;
    if(image != null) {
      this.image = File(image.path);
    }
    populateList();
    getAddress();
  }

  void getAddress() async {
    var addresses = await Geocoder.local.findAddressesFromQuery(position);
    var first = addresses.first;
    lat = first.coordinates.latitude;
    lon = first.coordinates.longitude;
  }

  void populateList() {
    List<List<List<int>>> ret = [];

    if(category == "Hotels and travels") {
      for(int i = 0; i < hours.length; i++) {
        if(hours[i][0] != -1) {
          ret.add([[concurrentAppointments, 0]]);
        } else {
          ret.add([[0, 0]]);
        }
      }
      appointments = ret;
      return;
    }

    for(int i = 0; i < hours.length; i++) {
      //7 days
      List<List<int>> d = [];
      int morningTime = 60 * (getHour(hours[i][1]) - getHour(hours[i][0])) + (getMinute(hours[i][1]) - getMinute(hours[i][0]));
      int afternoonTime = 60 * (getHour(hours[i][3]) - getHour(hours[i][2])) + (getMinute(hours[i][3]) - getMinute(hours[i][2]));
      int morningTurns = (morningTime / duration).floor();
      int afternoonTurns = (afternoonTime / duration).floor();
      int max;
      if(morningTurns < afternoonTurns) {
        max = afternoonTurns;
      } else {
        max = morningTurns;
      }
      if(max == 0) {
        ret.add([[0,0]]);
      }

      for (int j = 0; j < max; j++) {
        //Turn x before and after lunch
        List<int> t = [0,0];
        if (j < morningTurns) {
          t[0] = concurrentAppointments;
        } else {
          t[0] = 0;
        }
        if (j < afternoonTurns) {
          t[1] = concurrentAppointments;
        } else {
          t[1] = 0;
        }
        d.add(t);
        if(j >= morningTurns - 1 && j >= afternoonTurns - 1) {
          ret.add(d);
        }
      }
    }
    appointments = ret;
    return;
  }

  double toHour(int weekDay, int turn, int seq) {
    int startingHour = getHour(hours[weekDay][turn]);
    int startingMin = getMinute(hours[weekDay][turn]);
    double minutes = seq * duration / 60;
    int h = getHour(minutes);
    int m = (getMinute(minutes) * 0.6).toInt();
    int endingHour = startingHour + h;
    int endingMin = startingMin + m;
    if(endingMin >= 60) {
      endingMin = endingMin - 60;
      endingHour = endingHour + 1;
    }
    return toDouble(endingHour, endingMin);
  }
}
  int activityIndex = 6;
  List<Activity> allActivities = [
    Activity(0, "BCL", "Study and Work", "Milano, via Ampère 2", DateTime(DateTime.now().year - 2), ["", "Spaces for studying", "Book reservations"], 60, 50, initializeHours(), initializeTurns(), null),
    Activity(1, "BCC", "Study and Work", "Milano, via Candiani 72", DateTime(DateTime.now().year - 1), ["", "Spaces for studying", "Book reservations"], 60, 40, initializeHours(), initializeTurns(), null),
    Activity(2, "Cracco", "Food and drink", "Milano, Corso Vittorio Emanuele II", DateTime(DateTime.now().day - 10), ["", "Breakfast", "Lunch", "Dinner"], 60, 20, initializeHours(), initializeTurns(), null),
    Activity(3, "Hotel Milano Scala", "Hotels and travels", "Milano, via dell'Orso 7", DateTime(DateTime.now().month - 1), ["", "Night"], 30, 1, initializeHours(), initializeTurns(), null),
    Activity(4, "QC Termemilano", "Spa and Wellness", "Milano, Piazzale Medaglie d'Oro 2", DateTime(DateTime.now().month - 10), ["", "Daily spa", "Massages"], 30, 1, initializeHours(), initializeTurns(), null),
    Activity(5, "New Brand Cafè", "Food and drink", "Milano, via Giovanni Pascoli 55", DateTime(DateTime.now().month - 10), ["", "Breakfast", "Lunch", "Spritz"], 30, 1, initializeHours(), initializeTurns(), null),
  ];

  Activity createActivity() {
    activityIndex = activityIndex + 1;
    Activity a = Activity(activityIndex - 1, '', '', '', DateTime.now(), [''], 30, 1, initializeHours(), initializeTurns(), null);
    allActivities.add(a);
    log("Activity created");
    return a;
  }

  void clearActivities () {
    allActivities = [];
  }

  void deleteActivity (Activity activity) {
    for(int i = 0; i < allAppointments.length; i++) {
      if(allAppointments[i].activity.name == activity.name && allAppointments[i].activity.category == activity.category && allAppointments[i].activity.dateOfAdding == activity.dateOfAdding) {
        allAppointments.remove(allAppointments[i]);
        log("Appointment removed from all");
      }
    }
    for(int i = 0; i < appointments.length; i++) {
      if(appointments[i].activity.name == activity.name && appointments[i].activity.category == activity.category && appointments[i].activity.dateOfAdding == activity.dateOfAdding) {
        appointments.remove(appointments[i]);
        log("Appointment removed from next");
      }
    }
    for(int i = 0; i < incomingAppointments.length; i++) {
      if(incomingAppointments[i].activity.name == activity.name && incomingAppointments[i].activity.category == activity.category && incomingAppointments[i].activity.dateOfAdding == activity.dateOfAdding) {
        incomingAppointments.remove(incomingAppointments[i]);
        log("Appointment  from incoming");
      }
    }
    for(int i = 0; i < pastAppointments.length; i++) {
      if(pastAppointments[i].activity.name == activity.name && pastAppointments[i].activity.category == activity.category && pastAppointments[i].activity.dateOfAdding == activity.dateOfAdding) {
        pastAppointments.remove(pastAppointments[i]);
        log("Appointment removed from past");
      }
    }
    allActivities.remove(activity);
    log("Activity discarded");
  }