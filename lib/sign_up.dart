import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_library/home_screen.dart';
import 'package:my_library/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future SignUp() async {
    final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: mailController.text.trim(),
        password: passwordController.text.trim());

    print(user.user!.uid);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.user!.uid)
        .collection("userName")
        .add({"name": userNameController.text});

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    userNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 200,
            ),
            Text(
              "Kayıt Ol",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              height: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          }
                          return null;
                        },
                        controller: userNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Kullanıcı Adı',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          }
                          return null;
                        },
                        controller: mailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e-Posta',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          }

                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Parola',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bu alan boş bırakılamaz';
                          } else if (value != passwordController.text) {
                            return "Parola Eşleşmiyor!";
                          }
                          return null;
                        },
                        controller: rePasswordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Parola Tekrar',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          shape: StadiumBorder(),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kayıt Başarılı')),
                            );
                            SignUp();
                          }
                        },
                        child: Text('Kayıt Ol'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
