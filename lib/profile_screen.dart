// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  late Future<List<int>> bookCounts;

  @override
  Future<List<int>> getBookList() async {
    final preferences = await SharedPreferences.getInstance();

    final savedBooks = preferences.getStringList('savedBooks') ?? [];
    final savedLibraryBooks =
        preferences.getStringList('savedLibraryBooks') ?? [];

    final savedBookList =
        savedBooks.map((e) => Book.fromJson(json.decode(e))).toList();
    // this.savedBookCount = savedBookList.length;

    final savedLibraryBookList =
        savedLibraryBooks.map((e) => Book.fromJson(json.decode(e))).toList();
    // this.savedLibraryBookCount = savedLibraryBookList.length;
    int x = 0;
    return [savedBookList.length, savedLibraryBookList.length];
  }

  void initState() {
    bookCounts = getBookList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: bookCounts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final bookCount = snapshot.data;

          return Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green,
                ),
                child: Center(
                    child: Text(
                  "Profil",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
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
                        "Toplam okunan",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          bookCount![1].toString(),
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
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
                            "Bu ay okunan",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "0",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amberAccent,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Okunacak kitap",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              bookCount[0].toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
