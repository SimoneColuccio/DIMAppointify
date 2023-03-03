

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/Data/appointment.dart';
import 'package:my_app/Pages/accountPage.dart';
import '../Data/category.dart';
import '../Widgets/bottomMenu.dart';
import '../Widgets/infoPopup.dart';
import 'bookAppointmentPage.dart';

class IncomingAppPage extends StatefulWidget {
  const IncomingAppPage({super.key, required this.index});

  final int index;

  @override
  State<IncomingAppPage> createState() => _IncomingAppPageState(this.index);
}

List<Appointment> appointments = [];
List<Appointment> incomingAppointments = [];

class _IncomingAppPageState extends State<IncomingAppPage>{
  _IncomingAppPageState(this.ind);
  final int ind;
  final title = "Incoming Appointments";
  bool filtering = false;
  bool ordering = false;

  final dataController = TextEditingController();
  final dataFocusNode = FocusNode();

  final controller = TextEditingController();
  final searchFocusNode = FocusNode();

  List<String> categories = allCategories;

  var order = ["Ascending", "Descending"];
  String? ascending = "Ascending";
  var columns = ["Name", "Date"];
  String? parameter = "Date";

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
  String? filteredCategory = "";
  String filteredClient = "";

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(onFocusChanged);
  }
  void onFocusChanged() {
    if(searchFocusNode.hasFocus) {
      controller.text = filteredClient;
    }
  }

  @override
  Widget build(BuildContext context) {

    checkDates();

    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.red,
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              snap: false,
              title: Text(title),
              centerTitle: true,
              leading: ((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) ? TextButton(
                  onPressed: () {
                    ordering = true;
                    setState(() {});
                  },//Open filtering options
                  child: const Icon(Icons.list, color: Colors.white,)
              ) : null,
              actions: [
                if ((!filtering & !ordering) & (isLoggedAsUser | isLoggedAsActivity)) TextButton(
                    onPressed: () {
                      filtering = true;
                      ordering = false;
                      setState(() {});
                    },//Open filtering options
                    child: const Icon(Icons.filter_alt, color: Colors.white,)
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    if (ordering) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(
                                      width: 130,
                                      child: Text("Sort by")
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: parameter,
                                      items: columns.map((cat) => DropdownMenuItem<String>(
                                        value: cat,
                                        child: Text(cat, style: const TextStyle(fontSize: 15),
                                        ),
                                      )).toList(),
                                      onChanged: (cat) => setState(() {
                                        parameter = cat;
                                        log(parameter.toString());
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(
                                      width: 130,
                                      child: Text("Order")
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: ascending,
                                      items: order.map((cat) => DropdownMenuItem<String>(
                                        value: cat,
                                        child: Text(cat, style: const TextStyle(fontSize: 15),
                                        ),
                                      )).toList(),
                                      onChanged: (cat) => setState(() =>  ascending = cat),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(() {
                                      ordering = false;
                                      ascending = "Ascending";
                                      parameter = "Date";
                                    }), child: const Text("Reset"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      ordering = false;
                                      allAppointments = sortAppointments(parameter, ascending, allAppointments);
                                    }), child: const Text("Apply"),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (filtering) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 240,
                        child: Column(
                          children: [
                            isLoggedAsActivity ? TextField(
                              controller: controller,
                              focusNode: searchFocusNode,
                              onTap: () => setState(() {}),
                              onChanged: (text) => setState(() {}),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search for a specific client...',
                                suffixIcon: createSuffix(),
                              ),
                            ) : const SizedBox(height: 0),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(
                                      width: 130,
                                      child: Text("Category")
                                  ),
                                  //const SizedBox(width: 60,),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: filteredCategory,
                                      items: categories.map((cat) => DropdownMenuItem<String>(
                                        value: cat,
                                        child: Text(cat, style: const TextStyle(fontSize: 15),
                                        ),
                                      )).toList(),
                                      onChanged: (cat) => setState(() => filteredCategory = cat),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(
                                      width: 130,
                                      child: Text("Date")
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: dataController,
                                      focusNode: dataFocusNode,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.calendar_today), //icon of text field
                                          labelText: "Enter Date" //label text of field
                                      ),
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.datetime,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2100));

                                        if (pickedDate != null) {
                                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          date = pickedDate;
                                          setState(() {
                                            dataController.text = formattedDate; //set output date to TextField value.
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => setState(() {
                                      filteredCategory = "";
                                      date = DateTime(DateTime.now().year, DateTime.now().month + 1, DateTime.now().day);
                                      filtering = false;
                                      dataController.text = "";
                                      controller.text = "";
                                      filteredClient = "";
                                    }), child: const Text("Reset"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => setState(() {
                                      filteredClient = controller.text;
                                      log(filteredClient);
                                      filtering = false;
                                      controller.text = "";
                                      dataController.text = "";
                                    }), child: const Text("Apply"),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if(!filtering & !ordering) SizedBox(
                      height: 200,
                      child: Center(
                        child: (isLoggedAsUser || isLoggedAsActivity) ? ListView.builder(
                          itemCount: incomingAppointments.length,
                          itemBuilder: (context, index) {
                              final appointment = incomingAppointments[index];
                              if(!appointment.toShow && isLoggedAsUser) {
                                return const SizedBox();
                              }
                              return ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        isLoggedAsUser ? appointment.activity.name : appointment.user,
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        DateFormat('yyyy/MM/dd, kk:mm').format(appointment.dateTime),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.red
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        appointmentInfoPopup(appointment, context, "i"),
                                  );
                                },
                            );
                          },
                        ) : const Text("You have to log in to see your appointments"),
                      ),
                    ),
                    if (filtering || ordering &&(isLoggedAsUser || isLoggedAsActivity)) const Divider(color: Colors.red),
                    if((!filtering && !ordering) && (isLoggedAsUser || isLoggedAsActivity)) Container(
                      height: 1000,
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = appointments[index];
                          if(!appointment.toShow && isLoggedAsUser) {
                            return const SizedBox();
                          }
                          if((filteredCategory == "" || appointment.activity.category == filteredCategory) &&
                            (filteredClient == "" || appointment.user == filteredClient)) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      isLoggedAsUser ? appointment.activity.name : appointment.user,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      DateFormat('yyyy/MM/dd, kk:mm').format(appointment.dateTime),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/bookAppointment',
                                          arguments: BookAppointmentArguments(appointment),
                                        ).then(onGoBack);
                                      },
                                      icon: const Icon(Icons.edit)
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              _buildPopupDialogConfirm(
                                                  context, appointment, setState),
                                        );
                                      },
                                      icon: const Icon(Icons.delete)
                                  ),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      appointmentInfoPopup(appointment, context, "i"),
                                );
                              },
                          );
                          } else {
                            return const SizedBox(width: 0, height: 0,);
                          }
                        },
                      ),
                    ),
                  ]
              ),
            ) ,
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: ind,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.red.withOpacity(.60),
            onTap: (value) {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, '/');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/past');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/account');
                  break;
              }
            },
            items: getBottomMenu(incomingAppointments.length)
        )
    );
  }

  IconButton? createSuffix(){
    return searchFocusNode.hasFocus
        ? IconButton(
        onPressed: (){
          controller.text = "";
          searchFocusNode.unfocus();
          setState(() {});
          return;
        },
        icon: const Icon(Icons.clear)
    ) : null;
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  Widget _buildPopupDialogConfirm(BuildContext context, Appointment appointment, void Function(VoidCallback fn) setState) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text("If you delete this appointment you'll lose all related data"),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  deleteAppointment(appointment);
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: const Text("Yes"),
              ),
            )
          ],
        ),
      ],
    );
  }

}

List<Appointment> sortAppointments(String? parameter, String? ascending, List<Appointment> app) {
  log(parameter!);
  log(ascending!);
  switch (parameter) {
    case "Name":
      if(ascending == "Ascending") {
        app.sort((a, b) => a.activity.name.compareTo(b.activity.name));
      } else {
        app.sort((a, b) => - a.activity.name.compareTo(b.activity.name));
      }
      break;
    case "Date":
      if(ascending == "Ascending") {
        app.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      } else {
        app.sort((a, b) => - a.dateTime.compareTo(b.dateTime));
      }
      break;
    default :
      app.sort((a, b) => a.activity.name.compareTo(b.activity.name));
      break;
  }

  return app;
}