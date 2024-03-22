import 'package:flutter/material.dart';

//Princpial Widget of the view
class ForgotPassword extends StatefulWidget {
  const ForgotPassword ({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final TextEditingController _emailController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forgot Password',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color.fromARGB(255, 213, 213, 213),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      "assets/logo.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Recuperar Contraseña",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Email(controller: _emailController,),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: EmailButton(),
                ),
                //White space for better visual appearance
                const SizedBox(height: 300),
              ],
            )
          ),
        ),
      ),
    );
  }
}

//Widget to indicate the user's email address
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
        //Assign the TextField controller
        controller: controller,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          hintText: 'Email',
        ),
      ),
    );
  }
}

//Button to send an email to the selected email address.
class EmailButton extends StatelessWidget {
  const EmailButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        onPressed: () async {
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ), 
        child: const Text(
          'Enviar Correo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}