
import 'package:flutter/material.dart';

class PastAppPage extends StatefulWidget {
  const PastAppPage({super.key, required this.index});

  final int index;

  @override
  State<PastAppPage> createState() => _PastAppPageState(this.index);
}

class _PastAppPageState extends State<PastAppPage>{
  _PastAppPageState(this.ind);
  final int ind;
  final title = "Past Appointments";
  bool filtering = false;

  @override
  Widget build(BuildContext context) {
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
              actions: [
                if (!filtering) TextButton(
                    onPressed: () {
                      filtering = !filtering;
                      setState(() {});
                    },//Open filtering options
                    child: const Icon(Icons.filter_alt, color: Colors.black,)
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    if (filtering) Column(
                      children: [
                        for (int i = 0; i<10; i++) Row(
                          children: const [
                            Text("Filter options")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => setState(() {
                                  filtering = false;
                                }), child: const Text("Discard"),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => setState(() {
                                  filtering = false;
                                }), child: const Text("Apply"),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    if (filtering) const Divider(),
                    if(!filtering) Container(
                      height: 1000,
                      color: Colors.white,
                      child: const Text('Appointments to scroll'),
                    ),
                  ]
              ),
            ),
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
                case 1:
                  Navigator.pushNamed(context, '/incoming');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/account');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                label: 'HomePage',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Incoming',
                icon: Icon(Icons.calendar_today),
              ),
              BottomNavigationBarItem(
                label: 'Past Appointments',
                icon: Icon(Icons.calendar_month),
              ),
              BottomNavigationBarItem(
                label: 'Account',
                icon: Icon(Icons.account_circle),
              ),
            ]
        )
    );
  }
}