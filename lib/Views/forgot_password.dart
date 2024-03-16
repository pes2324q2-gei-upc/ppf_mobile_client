import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword ({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 100,
                    width: 100,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Email(controller: _emailController,),
              ),
              SizedBox(height: 300)
            ],
          )
        ),
      ),
    );
  }
}

class Email extends StatelessWidget {
  const Email({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          //border: OutlineInputBorder(),
          hintText: 'Email',
        ),
      ),
    );
  }
}