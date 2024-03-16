import 'package:flutter/material.dart';
import 'package:ppf_mobile_client/views/map_preview_screen.dart';
import 'package:ppf_mobile_client/views/register_screen.dart';

class TestingMenu extends StatefulWidget {
  const TestingMenu({super.key});

  @override
  State<TestingMenu> createState() => _TestingMenuState();
}

class _TestingMenuState extends State<TestingMenu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Testing Menu'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
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
