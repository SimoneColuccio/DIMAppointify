import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Data/category.dart';

import '../Pages/accountPage.dart';

Widget appointmentInfoPopup(Appointment appointment, BuildContext context, String date) {
  return AlertDialog(
    title: const Text('Appointment info'),
    content: SizedBox(
      height: MediaQuery
          .of(context)
          .copyWith()
          .size
          .height / 4,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  DateFormat('yy/MM/dd kk:mm').format(appointment.dateTime),
                  style: const TextStyle(fontSize: 19),
                ),
                appointment.activity.category != "Hotels and travels"
                  ? Text("  - ${appointment.duration} mins",
                    style: const TextStyle(fontSize: 19),)
                  : Text("  - ${appointment.duration} nights",
                    style: const TextStyle(fontSize: 19),),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              appointment.appointType,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(appointment.message),
            const SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: getIcon(appointment.activity.category, "")
                ),
                Text(appointment.activity.name),
              ],
            ),
            const SizedBox(height: 10),
            Text(appointment.activity.position),
          ],
        ),
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
              ],
            ),
            date == "i" ? StatefulBuilder(
              builder: (context, setState) {
                if(isLoggedAsUser && !appointment.userGoogleCalendar || !isLoggedAsUser && !appointment.actGoogleCalendar) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          appointment.addToCalendar(isLoggedAsUser);
                          setState(() {});
                          // TODO: implement Google Calendar
                        },
                        child: const FaIcon(FontAwesomeIcons.google)
                      )
                    ],
                  );
                } else {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("\nAdded to Google Calendar")
                      ]
                  );
                }
              }
            ) : const SizedBox(),
          ]
        ),
      ),
    ],
  );
}