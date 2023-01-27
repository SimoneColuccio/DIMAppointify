
class Activity {
  final String name;
  final String description;
  final String category;
  final String position;
  final double rating;
  final DateTime dateOfAdding;
  //Coordinates? coordinates;

  Activity( this.name,
     this.description,
     this.category,
     this.position,
     this.rating,
     this.dateOfAdding,
      ) {/* coordinates = getCoordinates() as Coordinates;*/}

  /*Future<Coordinates> getCoordinates () async {
    var addresses = await Geocoder.local.findAddressesFromQuery(position);
    var first = addresses.first;
    return first.coordinates;
  }*/

}

  List<Activity> allActivities = [
    Activity("first activity", "1st activity", "Beauty", "", 3.7, DateTime(DateTime.now().day - 1)),
    Activity("second activity", "2nd activity", "Food and drink", "", 3.8, DateTime.now()),
    Activity("third activity", "3rd activity", "Health", "", 4.1, DateTime(DateTime.now().day - 10)),
    Activity("fourth activity", "4th activity", "Hotels and travels", "", 3.5, DateTime(DateTime.now().month - 1)),
    Activity("fifth activity", "5th activity", "Spa and Wellness", "", 4.2, DateTime(DateTime.now().year - 1)),
  ];

  void createActivity(name, description, category, position, rating, dateOfAdding) {
    Activity a = Activity(name, description, category, position, rating, dateOfAdding);
    allActivities.add(a);
  }

  void clearActivities () {
    allActivities = [];
  }

  void deleteActivity (Activity activity) {
    allActivities.remove(activity);
  }