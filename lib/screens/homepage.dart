import 'package:flutter/material.dart';
import 'package:stephin_mess_management/screens/userinfopage.dart';

import 'userlist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle style = const TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
  int index = -1;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                return UserInfoPage();
              }));
            }, icon: Icon(Icons.add))
          ],
            title: const Text(
              "Foodie Bay",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.black,
            bottom: TabBar(
              enableFeedback: true,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 10),
              tabs: [
                Tab(
                  child: Text(
                    "Breakfast",
                    style: style,
                  ),
                ),
                Tab(
                    child: Text(
                  "Lunch",
                  style: style,
                )),
                Tab(
                  child: Text(
                    "Dinner",
                    style: style,
                  ),
                )
              ],
            )),
        body: TabBarView(
          children: [
            UserList("breakfast"),
            UserList("lunch"),
            UserList("dinner")
          ],
        ),
      ),
    );
  }
}
