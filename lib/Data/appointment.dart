import 'activity.dart';

class Appointment {
  final String user;
  final Activity activity;
  final DateTime dateTime;

  Appointment(this.user, this.activity, this.dateTime);
}

List<Appointment> allAppointments = [
  Appointment(
    "user1",
    Activity(
      allActivities[0].name,
      allActivities[0].description,
      allActivities[0].category,
      allActivities[0].position,
      allActivities[0].rating,
      allActivities[0].dateOfAdding,
    ),
    DateTime(DateTime.now().year, DateTime.now().month + 1)
  ),
  Appointment(
      "user2",
      Activity(
        allActivities[1].name,
        allActivities[1].description,
        allActivities[1].category,
        allActivities[1].position,
        allActivities[1].rating,
        allActivities[1].dateOfAdding,
      ),
      DateTime.now()
  ),
];