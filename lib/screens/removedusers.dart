import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stephin_mess_management/services/firestore_services.dart';

class RemovedUsers extends StatelessWidget {
  RemovedUsers(this.foodType, {super.key});

  final String foodType;
  List<QueryDocumentSnapshot> mydocs = [];
  List<QueryDocumentSnapshot> futureDocs = [];
  List<QueryDocumentSnapshot> finalDoc = [];

  void matchChecker() {
    for (int i = 0;i<mydocs.length;i++) {

      for (int j =0;j<futureDocs.length;j++) {
        if (mydocs[i].id == futureDocs[j].id) {
          futureDocs.remove(futureDocs[j]);

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor:Theme.of(context).primaryColor,title: Text("Add people to $foodType"),),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("food")
              .doc(DateFormat.yMMMd().format(DateTime.now()))
              .collection(foodType)
              .snapshots(),
          builder: (context, streamSnapshot) {
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            mydocs = streamSnapshot.data!.docs;
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection("users").get(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  futureDocs = snapshot.data!.docs;
                  matchChecker();
                  if (futureDocs
                      .isEmpty) {
                    return Center(child: Text("Everyone is already having $foodType",style: TextStyle(fontWeight: FontWeight.bold),));
                  } else {
                    return ListView.builder(
                      itemCount: futureDocs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> myData =
                            futureDocs[index].data() as Map<String, dynamic>;
                        return Card(
                          child: ListTile(
                            title: Text(myData["name"],style: TextStyle(fontWeight: FontWeight.bold),),
                            trailing: IconButton(onPressed: (){
                              FireStoreServices.addUser(futureDocs[index].id, myData['name'], foodType);
                              Navigator.of(context).pop();
                            },icon:const Icon(Icons.add,color: Colors.green,),),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            );
          }),
    );
  }
}
