
import 'dart:developer';

class Activity {
  String name;
  String description;
  String category;
  String position;
  DateTime dateOfAdding;
  //Coordinates? coordinates;

  double rating = 0.0;
  int votes = 0;

  Activity( this.name,
     this.description,
     this.category,
     this.position,
     this.dateOfAdding,
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
    log("voteActivity method");
    log(rating.toString());
    log(votes.toString());
  }

  void editActivity(name, category, description) {
    this.name = name;
    this.category = category;
    this.description = description;
  }

}

  List<Activity> allActivities = [
    Activity("first activity", "1st activity", "Beauty", "", DateTime(DateTime.now().day - 1)),
    Activity("second activity", "2nd activity", "Food and drink", "", DateTime.now()),
    Activity("third activity", "3rd activity", "Health", "", DateTime(DateTime.now().day - 10)),
    Activity("fourth activity", "4th activity", "Hotels and travels", "", DateTime(DateTime.now().month - 1)),
    Activity("fifth activity", "5th activity", "Spa and Wellness", "", DateTime(DateTime.now().year - 1)),
  ];

  void createActivity(name, description, category, position, dateOfAdding) {
    Activity a = Activity(name, description, category, position, dateOfAdding);
    allActivities.add(a);
  }

  void clearActivities () {
    allActivities = [];
  }

  void deleteActivity (Activity activity) {
    allActivities.remove(activity);
  }