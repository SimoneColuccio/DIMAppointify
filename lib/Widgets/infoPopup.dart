import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/appointment.dart';

import '../Pages/accountPage.dart';

Widget appointmentInfoPopup(Appointment appointment, BuildContext context, String date) {
  return AlertDialog(
    title: const Text('Appointment info'),
    content: SizedBox(
      height: 170,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('yy/MM/dd kk:mm').format(appointment.dateTime),
            style: const TextStyle(fontSize: 19),
          ),
          const SizedBox(height: 10),
          Text(
            appointment.appointType,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          Text(appointment.activity.name),
          const SizedBox(height: 10),
          Text(appointment.activity.category),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text("pos"),
              Text(appointment.activity.position),
            ],
          ),
        ],
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
                        },
                        child: const Icon(Icons.edit_calendar),
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
            ) : const SizedBox(height: 0),
          ]
        ),
      ),
    ],
  );
}