
import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Data/openingTime.dart';

class Activity {
  String name;
  String description;
  String category;
  String position;
  DateTime dateOfAdding;
  int duration;
  int concurrentAppointments;
  List<List<double>> hours;
  List<bool> continued;
  File? image;
  //Coordinates? coordinates;

  List<String> appTypes;
  double rating = 0.0;
  int votes = 0;
  List<List<List<int>>> appointments = [];

  Activity(
    this.name,
    this.description,
    this.category,
    this.position,
    this.dateOfAdding,
    this.appTypes,
    this.duration,
    this.concurrentAppointments,
    this.hours,
    this.continued,
    this.image
  ) {/* coordinates = getCoordinates() as Coordinates;*/}

  /*Future<Coordinates> getCoordinates () async {
    var addresses = await Geocoder.local.findAddressesFromQuery(position);
    var first = addresses.first;
    return first.coordinates;
  }*/

  void voteActivity (int vote) {
    double r = rating * votes;
    r = r + vote;
    votes = votes + 1;
    rating = r / votes;
  }

  void editActivity(name, category, description, appTypes, position, duration, concurrentAppointments, hours, continued, XFile? image) {
    this.name = name;
    this.category = category;
    this.description = description;
    this.appTypes = appTypes;
    this.position = position;
    this.duration = duration;
    this.concurrentAppointments = concurrentAppointments;
    this.hours = hours;
    this.continued = continued;
    if(image != null) {
      this.image = File(image.path);
    }
    appointments = populateList();
    log(appointments.toString());
  }

  List<List<List<int>>> populateList() {
    List<List<List<int>>> ret = [];

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
    return ret;
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

  List<Activity> allActivities = [
    Activity("first activity", "1st activity", "Beauty", "", DateTime(DateTime.now().day - 1), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns(), null),
    Activity("second activity", "2nd activity", "Food and drink", "", DateTime.now(), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns(), null),
    Activity("third activity", "3rd activity", "Health", "", DateTime(DateTime.now().day - 10), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns(), null),
    Activity("fourth activity", "4th activity", "Hotels and travels", "", DateTime(DateTime.now().month - 1), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns(), null),
    Activity("fifth activity", "5th activity", "Spa and Wellness", "", DateTime(DateTime.now().year - 1), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns(), null),
  ];

  Activity createActivity() {
    Activity a = Activity('', '', '', '', DateTime.now(), [''], 30, 1, initializeHours(), initializeTurns(), null);
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
        log("Appointment removed");
      }
    }
    allActivities.remove(activity);
    log("Activity discarded");
  }