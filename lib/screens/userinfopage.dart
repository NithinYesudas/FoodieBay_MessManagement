import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stephin_mess_management/screens/homepage.dart';
import 'package:stephin_mess_management/services/firestore_services.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _key = GlobalKey();
  bool isValid = false;

  Future<void> submit() async {
    isValid = _key.currentState!.validate();
    if (isValid) {
      await FireStoreServices.createUser(_nameController.text);



    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                children: [
                  SizedBox(
                      height: mediaQuery.height * .35,
                      width: mediaQuery.width,
                      child: Image.network(
                        "https://media.istockphoto.com/vectors/login-page-on-laptop-screen-notebook-and-online-login-form-sign-in-vector-id1264216428?b=1&k=20&m=1264216428&s=170667a&w=0&h=HEdl5Ocv_hQ_fD8hVTD1U0gPxZOxA2MsUc3XQphU5wM=",
                        fit: BoxFit.cover,
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * .05),
                    child: Form(
                        key: _key,
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Enter your name",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: TextFormField(
                                    controller: _nameController,
                                    keyboardType: TextInputType.text,
                                    maxLines: null,
                                    validator: (text) {
                                      if (text!.isEmpty && text.length < 4) {
                                        return "Invalid name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                        labelText: "Name",
                                        border: InputBorder.none,
                                        hintText: "Eg: Peter"),
                                  ),
                                )),
                            SizedBox(
                              height: mediaQuery.height * .05,
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  showDialog(context: context, builder: (ctx){
                                    return AlertDialog(
                                      title: const Text(
                                          "Add"),
                                      content: Text(
                                          "Do you really want to Add ${_nameController.text}"),
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
                                                  submit();

                                                  Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(builder: (ctx) => const HomePage()));
                                            },
                                            child:
                                            const Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors
                                                      .red),
                                            ))
                                      ],
                                    );
                                  });

                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: mediaQuery.width * .15),
                                  child: const Text(
                                    "Add",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ))
                          ],
                        )),
                  )
                ],
              ),
            ),
    );
  }
}
