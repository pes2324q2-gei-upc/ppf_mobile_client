import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/views/map_preview_screen.dart';
import 'package:ppf_mobile_client/views/register_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Screen'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Aquí va el contenido de tu pantalla de inicio de sesión

              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de registro al hacer clic en el botón
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),

                  );
                },
                child: const Text('Ir a la pantalla de registro'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la pantalla de registro al hacer clic en el botón
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapPreview(),
                    ),
                  );
                },
                child: const Text('Ir a la pantalla de preview de mapas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
