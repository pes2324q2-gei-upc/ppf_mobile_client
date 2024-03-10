import 'package:flutter/material.dart';

class SingUp extends StatelessWidget  {
  const SingUp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sing Up',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color.fromARGB(255, 213, 213, 213),
      ),
      home: const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Email(),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Password(),
            )
          ],
        ),),
    );
  }
}

class Email extends StatelessWidget {
  const Email({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: const TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          //border: OutlineInputBorder(),
          hintText: 'Email',
        ),
      ),
    );
  }
}

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {

  var hide = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextField(
        obscureText: hide,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          hintText: 'Password',
          suffixIcon: IconButton(
            icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                hide = !hide;
              });
            },
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
          border: InputBorder.none,
          //border: OutlineInputBorder(),
        ),
      ),
    );
  }
}