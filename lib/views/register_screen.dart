import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ppf_mobile_client/RemoteService/Remote_service.dart';
import 'package:email_validator/email_validator.dart';
import 'login_screen.dart';

//Register Screen initialization
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

//Register screen
class _RegistrationScreenState extends State<RegisterScreen> {
  
  //Register variables
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _capacidadMaximaDelVehiculoController = TextEditingController();
  var hide1 = true;
  DateTime? _selectedDate;
  XFile? _profileImage;
  bool _isDriver = false;
  RemoteService remoteService = RemoteService();

  //Register screen components
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[300],
      //SingleChildScrollView to deal with overflow when opening keyboard
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        //Column to show components from top to bottom
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Back button to go back to login screen
            _botonBack(),
            const SizedBox(height: 16.0),

            //Profile picture
            _imageSelector(),
            const SizedBox(height: 10.0),

            //Email text field
            _buildTextField(_emailController, 'Correo electrónico'),
            const SizedBox(height: 10.0),

            //Username text field
            _buildTextField(_userNameController, 'Nombre de Usuario'),
            const SizedBox(height: 10.0),

            //Name text field
            _buildNameSelector(),
            const SizedBox(height: 10.0),

            //Date selection field
            _buildDateSelector(),
            const SizedBox(height: 10.0),

            //Password text field
            _buildPasswordSelector(_passwordController, 'Contraseña'),
            const SizedBox(height: 10.0),

            //Confirm password text field
            _buildPasswordSelector(_confirmPasswordController, 'Repita la contraseña'),
            const SizedBox(height: 2.0),

            //Choosing to be or not to be (a driver :D)
            _buildDriverSelector(),
            const SizedBox(height: 10.0),

            //Driver specific fields, only shown if _isDriver is true
            _buildDriverFieldsSelector(),
            const SizedBox(height: 20.0),

            //Register button
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  //Constructors

  //Regular text field
  Widget _buildTextField(TextEditingController contr, String? hint) {
    return TextField(
      controller: contr,
      autofocus: false,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.normal),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  //Password text field
  Widget _buildPasswordSelector(TextEditingController pasCont, String hint) {
    return TextField(
      controller: pasCont,
      autofocus: false,
      obscureText: hide1,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.normal),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
          borderRadius: BorderRadius.circular(12),
        ),
        //Hide/Show password button
        suffixIcon: IconButton(
          icon: Icon(hide1 ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              hide1 = !hide1;
            });
          },
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ),
      ),
    );
  }

  //Number selection text field
  Widget _buildNumberField(TextEditingController contr, String? hint) {
    return TextField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9 .]'))],
      controller: contr,
      autofocus: false,
      style: const TextStyle(fontSize: 18.0),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.normal),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  //Date selection field
  Widget _buildDateSelector() {
    return InkWell(
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
            borderSide: const BorderSide(color: Color.fromRGBO(158, 158, 158, 1)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _selectedDate == null
        ? Text.rich(TextSpan(
          text: 'Fecha de nacimiento',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.normal),
          )
        )
        : Text.rich(TextSpan(
          text:
            '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[500],
            fontWeight: FontWeight.normal),
          )
        ),
      ),
    );
  }

  //Register button
  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      ),

      //Actions when the button is pressed
      onPressed: () async {
        //Register variables
        String userName = _userNameController.text;
        String firstName = _firstNameController.text;
        String lastName = _lastNameController.text;
        String email = _emailController.text;
        String password = _passwordController.text;
        String password2 = _confirmPasswordController.text;
        String dni = _dniController.text;
        String capacidad = _capacidadMaximaDelVehiculoController.text;
        String response;

        //Show error message when passwords are different
        if (password != password2) {
          _showError('Por favor, asegúrese de que repetir la contraseña correctamente');
        }

        //Show error message if email is not valid
        else if (!EmailValidator.validate(email)) {
          _showError('Por favor, introduzca una dirección de correo electrónico válida');
        }

        //Password and email are valid
        else {

          //Driver case
          if (_isDriver) {

            //Show error message if one of the fields is empty
            if (userName.isEmpty || email.isEmpty || _selectedDate == null || password.isEmpty || password2.isEmpty || dni.isEmpty || capacidad.isEmpty) {              
              _showError('Por favor, completa todos los campos');
            }
            
            //Check if the DNI is valid
            else if (!isValidDNI(dni) && !isValidNIE(dni)) {
              _showError('Por favor, introduzca un DNI/NIE válido');
            }

            //Register driver if all fields are full
            else {
              response = await remoteService.registerDriver(userName, firstName, lastName, email, password, password2, _selectedDate, dni, capacidad);
              
              //Redirect to home screen if registered correctly
              if (response == '') {
                Navigator.push(context,MaterialPageRoute(builder: (context) => const LogIn()));
              }
              
              //Show error while registering
              else {
                _showError(response);
              }

            }
          }

          //Non driver case
          else {

            //Show error message if one of the fields is empty
            if (userName.isEmpty || email.isEmpty || _selectedDate == null || password.isEmpty || password2.isEmpty) {
              _showError('Por favor, completa todos los campos');
            }

            //Register non driver if all fields are full
            else {
              response = await remoteService.registerUser(userName, firstName, lastName, email, password, password2, _selectedDate);
              
              //Redirect to home screen if registered correctly
              if (response == '') {
                Navigator.push(context,MaterialPageRoute(builder: (context) => const LogIn()));
              }

              //Show error while registering
              else {
                _showError(response);
              }

            }
          }
        }
      },

      //Register button text
      child: const Text.rich(
        TextSpan(
          text: 'Registrarse',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.normal
          )
        ),
      ),
    );
  }

  //Back button constructor
  Widget _botonBack() {
    return Row(
      children: [
        //Back button
        IconButton(
          icon: const Icon(Icons.arrow_back),
          //Click logic
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  //Profile picture selector constructor
  Widget _imageSelector() {
    return GestureDetector(
      //Image selection logic
      onTap: () async {
        XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
        setState(() {
          _profileImage = image;
        });
      },
      //Field where profile picture is shown
      child: CircleAvatar(
        radius: 75.0,
        backgroundColor: Colors.purple,
        //Set profile picture
        child: Stack(
          children: [
            _profileImage == null
            //Show icon if no profile picture has been selected
            ? const Icon(
              Icons.person,
              size: 150.0,
              color: Colors.white,
            )
            //Show selected profile picture
            : ClipOval(
              child: Image.file(
                File(_profileImage!.path),
                fit: BoxFit.cover,
                width: 150.0,
                height: 150.0,
              ),
            ),
            //Bottom left corner edit icon
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(0),
                child: Icon(
                  size: 45,
                  Icons.circle,
                  color:  Colors.grey[500],
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(6.5),
                child: Icon(
                  size: 30,
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  //Driver selecting slider constructor
  Widget _buildDriverSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //"Do you want to be a driver?" text
        const Text.rich(TextSpan(
          text: 'Quieres ser conductor?',
          style: TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ),
        //Slider to choose wether to be a driver
        Switch(
          activeColor: Colors.white,
          activeTrackColor: Colors.lightGreenAccent[700],
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey[500],
          value: _isDriver,
          onChanged: (value) {
            setState(() {
              _isDriver = value;
            });
          },
        ),
      ],
    );
  }

  //Driver specific fields selector
  Widget _buildDriverFieldsSelector() {
    return Visibility(
      visible: _isDriver, //Controls visibiliti based on _isDriver's value
      child: Column(
        children: [
          //DNI text field
          _buildTextField(_dniController, 'DNI/NIE'),
          const SizedBox(height: 10.0),

          //Max capacity field
          _buildNumberField(_capacidadMaximaDelVehiculoController, 'Autonomia máxima del vehículo (km)'),
        ],
      ),
    );
  }

  //Name selection constructor
  Widget _buildNameSelector() {
    return Row(
      children: [
        //First name text field
        Expanded(child: _buildTextField(_firstNameController, 'Nombre')),
        const SizedBox(width: 16),

        //Last name text field
        Expanded(child: _buildTextField(_lastNameController, 'Apellidos'))
      ],
    );
  }

  //Extra functions

  //Show errors
  Future<void> _showError(String error)async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(error),
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

  //Date selector
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

  //Check if DNI is valid
  bool isValidDNI(String dni) {
    // Regular expression for validating a string with 8 numbers followed by a letter
    final dniRegex = RegExp(r'^\d{8}[a-zA-Z]$');

    // Check if the string matches the regular expression
    return dniRegex.hasMatch(dni);
  }

  //Check if NIE is valid
  bool isValidNIE(String dni) {
    // Regular expression for validating a string with 8 numbers followed by a letter
    final dniRegex = RegExp(r'^[a-zA-Z]\d{7}[a-zA-Z]$');

    // Check if the string matches the regular expression
    return dniRegex.hasMatch(dni);
  }
}