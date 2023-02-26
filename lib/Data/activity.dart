
import 'dart:developer';

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
  //Coordinates? coordinates;

  List<String> appTypes;
  double rating = 0.0;
  int votes = 0;

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
    this.continued
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

  void editActivity(name, category, description, appTypes, duration, concurrentAppointments, hours, continued) {
    this.name = name;
    this.category = category;
    this.description = description;
    this.appTypes = appTypes;
    this.duration = duration;
    this.concurrentAppointments = concurrentAppointments;
    this.hours = hours;
    this.continued = continued;
    log(this.hours.toString());
  }

  void addAppointmentType(value) {
    appTypes.add(value);
  }
}

  List<Activity> allActivities = [
    Activity("first activity", "1st activity", "Beauty", "", DateTime(DateTime.now().day - 1), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns()),
    Activity("second activity", "2nd activity", "Food and drink", "", DateTime.now(), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns()),
    Activity("third activity", "3rd activity", "Health", "", DateTime(DateTime.now().day - 10), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns()),
    Activity("fourth activity", "4th activity", "Hotels and travels", "", DateTime(DateTime.now().month - 1), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns()),
    Activity("fifth activity", "5th activity", "Spa and Wellness", "", DateTime(DateTime.now().year - 1), ["", "a", "b"], 30, 1, initializeHours(), initializeTurns()),
  ];

  Activity createActivity(name, description, category, position, dateOfAdding, appTypes, duration, concurrentAppointments, hours, continued) {
    Activity a = Activity(name, description, category, position, dateOfAdding, appTypes, duration, concurrentAppointments, hours, continued);
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