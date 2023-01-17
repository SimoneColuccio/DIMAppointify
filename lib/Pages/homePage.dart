

import 'package:flutter/material.dart';
import 'package:my_app/Data/activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.index, required this.title});

  final int index;
  final String title;

  @override
  State<HomePage> createState() => _HomePageState(index, title);
}

class _HomePageState extends State<HomePage> {
  _HomePageState(this.ind, this.tit);
  final int ind;
  final String tit;
  //Icon customIcon = const Icon(Icons.search);
  //Widget customSearchBar = const Text('Search for an activity');

  final controller = TextEditingController();
  List<Activity> activities = allActivities;
  final searchFocusNode = FocusNode();

  bool filtering = false;
  bool sug = false;

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(onFocusChanged);
  }

  void onFocusChanged() {
    if(searchFocusNode.hasFocus) {
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tit),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          if (!filtering) SliverAppBar(
            backgroundColor: Colors.redAccent,
            automaticallyImplyLeading: false,
            floating: true,
            pinned: true,
            snap: false,
            title: Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
              child: TextField(
                controller: controller,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for something...',
                  suffixIcon: createSuffix(),
                ),
                onSubmitted: (text) {
                  Navigator.pushNamed(context, '/account');//When submitted go to account page
                  },
                onChanged: (text) {
                  setState(() {});
                },
                onTap: () => setState(() {
                  sug = true;
                }),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    filtering = !filtering;
                    searchFocusNode.unfocus();
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
                if(!searchFocusNode.hasFocus & !filtering) const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      'Main categories will appear here',
                    ),
                  ),
                ),
                if(!searchFocusNode.hasFocus & !filtering) const Divider(),
                if(!searchFocusNode.hasFocus & !filtering) Container(
                  height: 1000,
                  color: Colors.white,
                  child: const Text('Activities to scroll'),
                ),
                if(sug & !filtering) Container(
                  height: 1000,
                  color: Colors.white,
                  child: const Text('Suggestions to scroll'),
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
}