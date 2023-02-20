import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/appointment.dart';

Widget appointmentInfoPopup(Appointment appointment, BuildContext context) {
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
          const SizedBox(height: 70),
          Text(appointment.activity.name),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Back"),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}