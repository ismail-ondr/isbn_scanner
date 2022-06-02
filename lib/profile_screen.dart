// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_library/providers/book_repository_provider.dart';
import 'package:my_library/providers/saved_library_books_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'book/book_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int? savedBookCount;
  int? savedLibraryBookCount;
  late Future<List<dynamic>> bookCounts;

  @override
  Future<List<dynamic>> getBookList() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    var respectsQuery = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('libraryBooks2');
    var querySnapshot = await respectsQuery.get();
    var totalLibraryBooks = querySnapshot.docs.length;

    var respectsQuery2 = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('toReadBooks');
    var querySnapshot2 = await respectsQuery2.get();
    var totalSavedBooks = querySnapshot2.docs.length;

    final a = FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('userName');
    var query = await a.get();
    var userName = query.docs.first["name"];

    return [totalSavedBooks, totalLibraryBooks, userName];
  }

  void initState() {
    bookCounts = getBookList();

    super.initState();
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text("Evet"),
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Hayır"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Uyarı"),
      content: Text("Çıkış yapmak istediğinize emin misiniz ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: bookCounts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final bookCount = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green,
                ),
                child: Center(
                    child: Text(
                  bookCount![2].toString(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Container(
                  height: 100,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.redAccent,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Okunan Kitap Sayısı",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            bookCount[1].toString(),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Okunacak Kitap Sayısı",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            bookCount[0].toString(),
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 90,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                onPressed: () {
                  showAlertDialog(context);
                },
                child: Text('Çıkış Yap'),
              ),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
