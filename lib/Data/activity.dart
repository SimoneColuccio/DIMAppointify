
import 'dart:developer';

class Activity {
  String name;
  String description;
  String category;
  String position;
  DateTime dateOfAdding;
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

  void editActivity(name, category, description, appTypes) {
    this.name = name;
    this.category = category;
    this.description = description;
    this.appTypes = appTypes;
  }

  void addAppointmentType(value) {
    appTypes.add(value);
  }
}

  List<Activity> allActivities = [
    Activity("first activity", "1st activity", "Beauty", "", DateTime(DateTime.now().day - 1), ["", "a", "b"]),
    Activity("second activity", "2nd activity", "Food and drink", "", DateTime.now(), ["", "a", "b"]),
    Activity("third activity", "3rd activity", "Health", "", DateTime(DateTime.now().day - 10), ["", "a", "b"]),
    Activity("fourth activity", "4th activity", "Hotels and travels", "", DateTime(DateTime.now().month - 1), ["", "a", "b"]),
    Activity("fifth activity", "5th activity", "Spa and Wellness", "", DateTime(DateTime.now().year - 1), ["", "a", "b"]),
  ];

  Activity createActivity(name, description, category, position, dateOfAdding, appTypes) {
    Activity a = Activity(name, description, category, position, dateOfAdding, appTypes);
    allActivities.add(a);
    log("Activity created");
    return a;
  }

  void clearActivities () {
    allActivities = [];
  }

  void deleteActivity (Activity activity) {
    allActivities.remove(activity);
    log("Activity discarded");
  }