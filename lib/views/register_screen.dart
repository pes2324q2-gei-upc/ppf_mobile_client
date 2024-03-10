import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen ({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _DNIController = TextEditingController();
  final TextEditingController _capacidadMaximaDelVehiculoController = TextEditingController();
  DateTime? _selectedDate;
  XFile? _profileImage;
  bool _isDriver = false;
  
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 211, 211, 211),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () async {
                XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                setState(() {
                  _profileImage = image;
                });
              },
              child: CircleAvatar(
                radius: 75.0,
                backgroundColor: Colors.purple,
                child: _profileImage == null
                    ? const Icon(
                        Icons.person,
                        size: 150.0,
                        color: Colors.white,
                      )
                    : ClipOval(
                        child: Image.file(
                          File(_profileImage!.path),
                          fit: BoxFit.cover,
                          width: 150.0,
                          height: 150.0,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _emailController,
              autofocus: false,
              style: const TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'email',
                hintStyle: const TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),
                contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _usernameController,
              autofocus: false,
              style: const TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nombre completo',
                hintStyle: const TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),
                contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            InkWell(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
                child: _selectedDate == null
                    ? const Text.rich(
                        TextSpan(text:'Fecha de nacimiento', style: TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),)
                    )
                    : Text.rich(
                        TextSpan(text:'${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}', style:const TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),)
                      ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              autofocus: false,
              obscureText: true,
              style: const TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Contraseña',
                hintStyle: const TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),
                contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _confirmPasswordController,
              autofocus: false,
              style: const TextStyle(fontSize: 18.0),
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirmar contraseña',
                hintStyle: const TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),
                contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text.rich(
                  TextSpan(text:'Quieres ser conductor?', style: TextStyle(fontSize: 18.0,color: Colors.black, fontWeight: FontWeight.bold),)
                ),
                Switch(
                  activeColor: Colors.white,
                  activeTrackColor: Colors.green,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                  value: _isDriver,
                  onChanged: (value) {
                    setState(() {
                      _isDriver = value;
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: _isDriver, // Controla la visibilidad basándote en el valor de _isDriver
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _DNIController,
                    autofocus: false,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'DNI',
                      hintStyle: const TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: _capacidadMaximaDelVehiculoController,
                    autofocus: false,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Capacidad máxima del vehículo',
                      hintStyle: const TextStyle(fontSize: 18.0, color: Color.fromARGB(255, 117, 117, 117), fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            /*
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                // Lógica de registro
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String DNI = _DNIController.text;
                String capacidadMaximaDelVehiculo = _capacidadMaximaDelVehiculoController.text;

                // Puedes imprimir los valores
                print('Nombre de usuario: $username');
                print('Fecha de nacimiento: $_selectedDate');
                print('Correo electrónico: $email');
                print('Contraseña: $password');
                print('DNI: $DNI');
                print('capacidadMaximaDelVehiculo: $capacidadMaximaDelVehiculo');
              },
              child: const Text.rich(
                TextSpan(text:'Registrarse', style: TextStyle(fontSize: 18.0,color: Colors.white, fontWeight: FontWeight.normal),)
              ),
            ),
            */
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              onPressed: () {
                // Lógica de registro
                String username = _usernameController.text;
                String email = _emailController.text;
                String password = _passwordController.text;
                String password2 = _confirmPasswordController.text;
                String DNI = _DNIController.text;
                String capacidad = _capacidadMaximaDelVehiculoController.text;

                //contraseñas diferentes
                if (password != password2) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Por favor, asegúrese de que repetir la contraseña correctamente'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                //contraseñas iguales
                else {
                  // Validación de campos si es conductor
                  if (_isDriver) {
                    if (
                        username.isEmpty || 
                        email.isEmpty || 
                        _selectedDate == null ||
                        password.isEmpty || 
                        password2.isEmpty || 
                        DNI.isEmpty || 
                        capacidad.isEmpty
                      ) {
                      // Muestra un mensaje de error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Por favor, completa todos los campos.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } 
                    //Registrar conductor
                    else {
                      // Todos los campos están completos, puedes continuar con la lógica de registro
                      // ...

                      // Imprime los valores
                      print('Nombre de usuario: $username');
                      print('Correo electrónico: $email');
                      print('Contraseña: $password');
                      print('DNI: $DNI');
                      print('capacidad: $capacidad');
                    }
                  }
                  //Validacion de campos si no es conductor
                  else {
                    if (
                        username.isEmpty || 
                        email.isEmpty || 
                        _selectedDate == null ||
                        password.isEmpty || 
                        password2.isEmpty
                      ) {
                      // Muestra un mensaje de error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Por favor, completa todos los campos.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } 
                    //Registrar no conductor
                    else {
                      // Todos los campos están completos, puedes continuar con la lógica de registro
                      // ...

                      // Imprime los valores
                      print('Nombre de usuario: $username');
                      print('Correo electrónico: $email');
                      print('Contraseña: $password');
                    }
                  }
                }
              },
              child: const Text.rich(
                TextSpan(text: 'Registrarse', style: TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.normal)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}