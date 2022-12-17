import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FireStoreServices {
  static Future<void> addUser(String uid, String name, String foodType) async {
    await FirebaseFirestore.instance
        .collection("food")
        .doc(DateFormat.yMMMd().format(DateTime.now()))
        .collection(foodType)
        .doc(uid)
        .set({"name": name});
  }
  static Future<void> deleteUser(String uid,String foodType) async{
    var date = DateTime.now();
    await FirebaseFirestore.instance
        .collection("food")
        .doc(DateFormat.yMMMd().format(date))
        .collection(foodType)
        .doc(uid)
        .delete();
  }
  static Future<void> createUser(String name)async {
    final firestore = FirebaseFirestore.instance;
    var ref = await firestore.collection("users").add({
      "name": name

    });
    final uid = ref.id;

     var date = DateTime.now();

    while (date.compareTo(DateTime(2024)) <= 0) {
      await firestore
          .collection("food")
          .doc(DateFormat.yMMMd().format(date))
          .collection("breakfast")
          .doc(uid)
          .set({"userId": uid});

      await firestore
          .collection("food")
          .doc(DateFormat.yMMMd().format(date))
          .collection("lunch")
          .doc(uid)
          .set({"userId": uid});

      await firestore
          .collection("food")
          .doc(DateFormat.yMMMd().format(date))
          .collection("dinner")
          .doc(uid)
          .set({"userId": uid});
      date = date.add(const Duration(days: 1));
    }

  }
}
