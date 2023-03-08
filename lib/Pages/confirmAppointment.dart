import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Data/appointment.dart';
import '../Widgets/bottomMenu.dart';
import 'accountPage.dart';

class ConfirmAppointment extends StatefulWidget {
  const ConfirmAppointment({super.key});

  @override
  State<StatefulWidget> createState() => _ConfirmAppointmentState();
}

class AppointmentArguments {
  Appointment appointment;
  AppointmentArguments(this.appointment);
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  late Appointment appointment;
  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as AppointmentArguments;
    appointment = args.appointment;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text("Appointment confirmed!"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your appointment at ${appointment.activity.name} has been confirmed!",
              style: const TextStyle(
                fontSize: 25
              ),
            ),

            Text("\n${DateFormat('yyyy-MM-dd, kk:hh').format(appointment.dateTime)}",
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            Text(appointment.activity.position,
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            Text("\nService booked: ${appointment.appointType}",
              style: const TextStyle(
                  fontSize: 17
              ),
            ),
            Text("Duration of your appointment: ${appointment.duration} ${appointment.activity.category == "Hotels and travels" ? "nights" : "mins"}",
              style: const TextStyle(
                  fontSize: 17
              ),
            ),
            Text("\nAppointment number: ${appointment.index}",
              style: const TextStyle(
                  fontSize: 17
              ),
            ),
            const Text("Save this number until the day of the appointment",
              style: TextStyle(
                  fontSize: 13
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  IconButton(
                    onPressed: () {
                      // TODO: implement share via WhatsApp
                    },
                    icon: const Icon(Icons.whatsapp,
                      size: 40,
                      color: Colors.green,
                    )
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                      onPressed: () {
                        // TODO: implement share via email
                      },
                      icon: const Icon(Icons.mail,
                        size: 40,
                        color: Colors.blue,
                      )
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                      onPressed: () {
                        appointment.addToCalendar(isLoggedAsUser);
                        setState(() {});
                        // TODO: implement Google Calendar
                      },
                      icon: const Icon(Icons.edit_calendar,
                        size: 40,
                        color: Colors.red,
                      )
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 50)
                      ),
                      onPressed: () => setState(() {
                        Navigator.pushNamed(context, '/');
                      }), child: const Text("Go to Homepage"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50)
                      ),
                      onPressed: () => setState(() {
                        Navigator.pushNamed(context, '/incoming');
                      }), child: const Text("Go to your incoming appointments"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.red.withOpacity(.60),
            onTap: (value) {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, '/');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/incoming');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/past');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/account');
                  break;
              }
            },
            items: getBottomMenu(0)
        )
    );
  }

}