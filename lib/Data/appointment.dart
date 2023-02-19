import 'activity.dart';

class Appointment {
  final String user;
  final Activity activity;
  final DateTime dateTime;
  final String appointType;
  int voted = -1;

  Appointment(this.user, this.activity, this.dateTime, this.appointType);
}

List<Appointment> allAppointments = [
  Appointment(
    "user1",
    Activity(
      allActivities[0].name,
      allActivities[0].description,
      allActivities[0].category,
      allActivities[0].position,
      allActivities[0].dateOfAdding,
    ),
    DateTime(DateTime.now().year, 02, 01, 23, 00),
    "type1"
  ),
  Appointment(
      "user2",
      Activity(
        allActivities[0].name,
        allActivities[0].description,
        allActivities[0].category,
        allActivities[0].position,
        allActivities[0].dateOfAdding,
      ),
      DateTime.now(),
      "type2"
  ),
];