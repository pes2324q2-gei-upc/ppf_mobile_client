import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppf_mobile_client/RemoteService/Remote_service.dart';

//Inicialización de la pantalla de Registro
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

//Pantalla de registro
class _RegistrationScreenState extends State<RegisterScreen> {
  final TextEditingController _userNameController = 
  TextEditingController();
  final TextEditingController _firstNameController = 
  TextEditingController();
  final TextEditingController _lastNameController = 
  TextEditingController();
  final TextEditingController _emailController = 
  TextEditingController();
  final TextEditingController _passwordController = 
  TextEditingController();
  final TextEditingController _confirmPasswordController = 
  TextEditingController();
  final TextEditingController _DNIController = 
  TextEditingController();
  final TextEditingController _capacidadMaximaDelVehiculoController = 
  TextEditingController();
  var hide1 = true;
  DateTime? _selectedDate;
  XFile? _profileImage;
  bool _isDriver = false;
  RemoteService remoteService = RemoteService();

  //Selección de fecha
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

  //Componentes de la página de Registro
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 211, 211, 211),
      //SingleChildScrollView para gestionar el overflow vertical haciendo que se pueda escrollear
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        //Column para que se añadan los componentes de arriba a bajo
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Botón de Back, para volver a la pantalla de Login
            Row(
              children: [
                //Botón de back
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  //Lógica de click
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 16.0),
            //Campo de imagen de Usuario
            GestureDetector(
              //Logica de detección de imagen
              onTap: () async {
                XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                setState(() {
                  _profileImage = image;
                });
              },
              //Campo donde se muestra la imagen de perfil
              child: CircleAvatar(
                radius: 75.0,
                backgroundColor: Colors.purple,
                //Setear imagen de perfil
                child: _profileImage == null
                    //Mostrar icono si no se ha seleccionado una foto de perfil
                    ? const Icon(
                        Icons.person,
                        size: 150.0,
                        color: Colors.white,
                      )
                    //Mostrar foto seleccionada en caso de que se haya seleccionado una
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
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 10.0),
            //Campo de texto de email
            TextField(
              controller: _emailController,
              autofocus: false,
              style: const TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'email',
                hintStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 117, 117, 117),
                    fontWeight: FontWeight.normal),
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
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 10.0),
            //Campo de texto de Nombre Completo
            TextField(
              controller: _userNameController,
              autofocus: false,
              style: const TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nombre de Usuario',
                hintStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 117, 117, 117),
                    fontWeight: FontWeight.normal),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    autofocus: false,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Nombre',
                      hintStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
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
                ),
                const SizedBox(width: 16), // Agrega un espacio entre los campos
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    autofocus: false,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Apellido',
                      hintStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
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
                ),
              ],
            ),
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 10.0),
            //Campo de selección de fecha
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
                    ? const Text.rich(TextSpan(
                        text: 'Fecha de nacimiento',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 117, 117, 117),
                            fontWeight: FontWeight.normal),
                      ))
                    : Text.rich(TextSpan(
                        text:
                            '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
                        style: const TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 117, 117, 117),
                            fontWeight: FontWeight.normal),
                      )),
              ),
            ),
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 10.0),
            //Campo de texto de contraseña
            TextField(
              controller: _passwordController,
              autofocus: false,
              obscureText: hide1,
              style: const TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Contraseña',
                hintStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 117, 117, 117),
                    fontWeight: FontWeight.normal),
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
                //Boton de ocultar la contraseña
                suffixIcon: IconButton(
                  icon: Icon(hide1 ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      hide1 = !hide1;
                    });
                  },
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                ),
              ),
            ),
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 10.0),
            //Campo de texto de Confirmar contraseña
            TextField(
              controller: _confirmPasswordController,
              autofocus: false,
              style: const TextStyle(fontSize: 18.0),
              obscureText: hide1,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Confirmar contraseña',
                hintStyle: const TextStyle(
                    fontSize: 18.0,
                    color: Color.fromARGB(255, 117, 117, 117),
                    fontWeight: FontWeight.normal),
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
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 2.0),
            //Selección de si quieres ser conductor
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Texto de si quieres ser conductor
                const Text.rich(TextSpan(
                  text: 'Quieres ser conductor?',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
                //Seleccionador de si quieres ser conductor
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
            //Campos de Conductor, solo se muestran quando _isDriver es true
            Visibility(
              visible:
                  _isDriver, // Controla la visibilidad basándote en el valor de _isDriver
              child: Column(
                children: [
                  //Caja para dejar espacio entre los campos
                  const SizedBox(height: 10.0),
                  //Campo de texto del DNI
                  TextField(
                    controller: _DNIController,
                    autofocus: false,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'DNI',
                      hintStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
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
                  //Caja para dejar espacio entre los campos
                  const SizedBox(height: 10.0),
                  //Campo de texto de la Capacidad máxima del vehículo
                  TextField(
                    controller: _capacidadMaximaDelVehiculoController,
                    autofocus: false,
                    style: const TextStyle(fontSize: 18.0),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Capacidad máxima del vehículo (km)',
                      hintStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontWeight: FontWeight.normal),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
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
            //Caja para dejar espacio entre los campos
            const SizedBox(height: 20.0),
            //Boton de registro
            ElevatedButton(
              //Formato basico
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              ),
              //Acciones al apretarlo
              onPressed: () {
                // Lógica de registro
                String userName = _userNameController.text;
                String firstName = _firstNameController.text;
                String lastName = _lastNameController.text;
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
                        content: const Text(
                            'Por favor, asegúrese de que repetir la contraseña correctamente'),
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
                    if (userName.isEmpty ||
                        email.isEmpty ||
                        _selectedDate == null ||
                        password.isEmpty ||
                        password2.isEmpty ||
                        DNI.isEmpty ||
                        capacidad.isEmpty) {
                      // Muestra un mensaje de error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Por favor, completa todos los campos.'),
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
                      // Imprime los valores
                      print('Nombre de usuario: $userName');
                      print('First Name: $firstName');
                      print('Last Name: $lastName');
                      print('Correo Electronico: $email');
                      print('Contraseña: $password');
                      print('Contraseña2: $password2');
                      print('DNI: $DNI');
                      print('capacidad: $capacidad');
                      // Todos los campos están completos, puedes continuar con la lógica de registro

                      remoteService.registerDriver(
                          userName,
                          firstName,
                          lastName,
                          email,
                          password,
                          password2,
                          _selectedDate,
                          DNI,
                          capacidad);
                    }
                  }
                  //Validacion de campos si no es conductor
                  else {
                    if (userName.isEmpty ||
                        email.isEmpty ||
                        _selectedDate == null ||
                        password.isEmpty ||
                        password2.isEmpty) {
                      // Muestra un mensaje de error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Por favor, completa todos los campos.'),
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
                      // Imprime los valores
                      print('Nombre de usuario: $userName');
                      print('First Name: $firstName');
                      print('Last Name: $lastName');
                      print('Correo Electronico: $email');
                      print('Contraseña: $password');
                      print('Contraseña2: $password2');

                      // Todos los campos están completos, puedes continuar con la lógica de registro
                      // ...
                      remoteService.registerUser(userName, firstName, lastName,
                          email, password, password2, _selectedDate);
                    }
                  }
                }
              },
              //Texto del boton de registro
              child: const Text.rich(
                TextSpan(
                    text: 'Registrarse',
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
