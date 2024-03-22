import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/Views/forgot_password.dart';
import 'package:ppf_mobile_client/Views/register_screen.dart';
import 'package:ppf_mobile_client/RemoteService/Remote_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//Princpial Widget of the view
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

//Widget to register in the application
class SignUpOption extends StatelessWidget {
  const SignUpOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('¿No tienes cuenta?'),
        const SizedBox(width: 5,),
        GestureDetector(
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
        ),
      ],
    );
  }
}

//Widget to start log in with other platforms
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
          //Navigate to the view to log in with other platforms
          MaterialPageRoute(builder: (context) => const Placeholder()),
        );
      },
      icon: icon,
      color: Colors.white,
    );
  }
}

//Button to confirm credentials and login to the application
class LogInButton extends StatefulWidget {
  const LogInButton({
    super.key,
    required this.emailController,
    required this.passwordController
  });
  
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LogInButton> createState() => _LogInButtonState();
}

class _LogInButtonState extends State<LogInButton> {

  //Variable that determines whether an error message is to be printed or not.
  var error = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //If an error has occurred while starting the session, a text is written indicating it
        if (error) 
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Error: Credenciales Inválidas",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        SizedBox(
          height: 50,
          width: 250,
          child: ElevatedButton(
            onPressed: () async {
              RemoteService rs = RemoteService();
              String token = await rs.logInUser(widget.emailController.text, widget.passwordController.text);
                //If the connection has been executed correctly without errors
                if (token != 'Invalid credentials') {
                  const storage = FlutterSecureStorage();
                  await storage.write(key: 'token', value: token);
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                }
                else {
                  //If there has been a problem logging in, we warn that there is an error.
                  setState(() {
                    error = true;
                  });
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
        ),
      ],
    );
  }
}

//Widget to go to ForgotPassword view
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

//Widget to display the user's password
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

  //Variable that determines whether to hide the written text or not.
  var hide = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: TextField(
        //Assign the TextField controller
        controller: widget.controller,
        obscureText: hide,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15.0),
          hintText: 'Password',
          suffixIcon: IconButton(
            //Depending on the value of hide, an icon is assigned to it.
            icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                hide = !hide;
              });
            },
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}