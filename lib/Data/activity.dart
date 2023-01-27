class Activity {
  final String name;
  final String description;
  final String category;
  final double position;
  final double rating;

  Activity({
    required this.name,
    required this.description,
    required this.category,
    required this.position,
    required this.rating,
  });
}

  List<Activity> allActivities = [];

  void createActivity(name, description, category, position, rating) {
    Activity a = Activity(name: name, description: description, category: category, position: position, rating: rating);
    allActivities.add(a);
  }

  void clearActivities () {
    allActivities = [];
  }

  void deleteActivity (Activity activity) {
    allActivities.remove(activity);
  }