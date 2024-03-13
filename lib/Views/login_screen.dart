import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppf_mobile_client/views/ForgotPasswordStub.dart';

class LogIn extends StatelessWidget  {
  const LogIn ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sing Up',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: const Color.fromARGB(255, 213, 213, 213),
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                "assets/logo.png",
                height: 200,
                width: 200,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Email(),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Password(),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ForgotPassword(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: LogInButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AutentificationButton(icon: Image.asset('assets/GoogleLogo.png',width: 50.0,height: 50.0,)),
                  const SizedBox(width: 30),
                  AutentificationButton(icon: Image.asset('assets/FacebookLogo.png',width: 50.0,height: 50.0,)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('¿No tienes cuenta?'),
                  SizedBox(width: 5,),
                  SignInLink(),
                ],
              ),
            )
          ],
        ),),
    );
  }
}

class SignInLink extends StatelessWidget {
  const SignInLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
      child: const Text(
        'Sign In',
        style: TextStyle(
          color: Color.fromARGB(255, 26, 95, 31),
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AutentificationButton extends StatelessWidget {
  const AutentificationButton({
    super.key,
    required this.icon
  });

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
      icon: icon,
      color: Colors.white,
    );
  }
}

class LogInButton extends StatelessWidget {
  const LogInButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            //INFO
            MaterialPageRoute(builder: (context) => const Placeholder()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ), 
        child: const Text(
          'Log in',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordStub()),
        );
      },
      child: const Text(
        '¿Has olvidado la contraseña?',
        style: TextStyle(
          color: Color.fromARGB(255, 26, 95, 31),
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.bold,
        ),
      ),
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