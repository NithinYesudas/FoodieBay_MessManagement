import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stephin_mess_management/screens/removedusers.dart';

import '../services/firestore_services.dart';

class UserList extends StatelessWidget {
   UserList(this.foodType, {super.key});

  final String foodType;
  List? docs = [];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>RemovedUsers(foodType)));


        },
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        //for fetching the user id of users in respective food list
          stream: FirebaseFirestore.instance
              .collection("food")
              .doc(DateFormat.yMMMd().format(DateTime.now()))
              .collection(foodType)
              .snapshots(),
          builder: (ctx, AsyncSnapshot snapshots) {
            return snapshots.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : snapshots.hasData == false
                ? const Center(
              child: Text("no data"),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        if (index < 0) {
                          return const Center(
                            child: Text("no data"),
                          );
                        }
                        String docId =
                            snapshots.data!.docs.toList()
                            [index].id;
                        docs = snapshots.data!.docs.toList();


                        return FutureBuilder(
                          //for fetching the data of userid got from stream
                            future: FirebaseFirestore.instance
                                .collection("users")
                                .doc(docId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot>
                                futureSnapshot) {
                              if (futureSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox();
                              } else if (futureSnapshot.hasData ==
                                  false) {
                                return const Text("no data");
                              } else {
                                Map<String, dynamic> myData =
                                futureSnapshot.data!.data()
                                as Map<String, dynamic>;
                                return Card(
                                  child: ListTile(

                                    title: Text(
                                      myData["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          mediaQuery.width * .05),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        try {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      "Remove..!"),
                                                  content: Text(
                                                      "Do you really want to remove from $foodType"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed:
                                                            () {
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                        child:
                                                        const Text(
                                                          "No",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87),
                                                        )),
                                                    TextButton(
                                                        onPressed:
                                                            () {
                                                          FireStoreServices
                                                              .deleteUser(
                                                              docId,
                                                              foodType);
                                                          Navigator.of(
                                                              context)
                                                              .pop();
                                                        },
                                                        child:
                                                        const Text(
                                                          "Remove",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red),
                                                        ))
                                                  ],
                                                );
                                              });
                                        } catch (error) {
                                          ScaffoldMessenger.of(
                                              context)
                                              .showSnackBar(SnackBar(
                                              content: Text(error
                                                  .toString())));
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            });
                      }),
                ),
                Card(
                  elevation: 5,
                  child: SizedBox(
                    width: mediaQuery.width,
                    height: mediaQuery.height * .05,
                    child: Center(
                        child: Text(
                          "Total $foodType: ${snapshots.data!.docs
                              .length}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: mediaQuery.width * .05),
                        )),
                  ),
                )
              ],
            );
          }),
    );
  }
}
