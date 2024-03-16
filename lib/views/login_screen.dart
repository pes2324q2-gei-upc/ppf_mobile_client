import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/Views/forgot_password.dart';
import 'package:ppf_mobile_client/Views/register_screen.dart';
import 'package:ppf_mobile_client/RemoteService/Remote_service.dart';

class LogIn extends StatefulWidget  {
  const LogIn ({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  MaterialApp build(BuildContext context) {
    return MaterialApp(
      title: 'Sing Up',
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
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    "assets/logo.png",
                    height: 200,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Email(controller: _emailController,),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Password(controller: _passwordController,),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ForgotPasswordLink(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: LogInButton(emailController: _emailController, passwordController: _passwordController),
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
                  child: SignUpOption(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpOption extends StatelessWidget {
  const SignUpOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('¿No tienes cuenta?'),
        SizedBox(width: 5,),
        SignInLink(),
      ],
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
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
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
    required this.emailController,
    required this.passwordController
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 250,
      child: ElevatedButton(
        onPressed: () async {
          RemoteService rs = RemoteService();
          String token = await rs.logInUser(emailController.text, passwordController.text);
            if (token != 'Invalid credentials') {
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                //INFO
                MaterialPageRoute(builder: (context) => const Placeholder()),
              );
            }
            else {
            }
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

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink ({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPassword()),
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

class Password extends StatefulWidget {
  const Password({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

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
        controller: widget.controller,
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