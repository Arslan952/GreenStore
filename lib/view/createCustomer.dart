import 'package:flutter/material.dart';
import 'package:green_commerce/models/customerModel.dart';
import 'package:green_commerce/view/auth/login_screen.dart';
import 'package:woosignal/woosignal.dart';

import '../repository/apis_call.dart';

class CreateCustomerScreen extends StatefulWidget {
  @override
  _CreateCustomerScreenState createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true; // To toggle the password visibility

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _createCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      CustomerModel customerModel = CustomerModel(
        email: _emailController.text,
        fullName: _firstNameController.text + _lastNameController.text,
        password: _passwordController.text,
      );

      bool isSuccess = await CallWooSignal().registerUser(customerModel);

      setState(() {
        _isLoading = false;
      });

      if (isSuccess) {
        // Clear form fields
        _firstNameController.clear();
        _lastNameController.clear();
        _passwordController.clear();
        _emailController.clear();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Customer created successfully!")),
        );

        // Pop out the screen (navigate back)
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create customer.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Register User",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: MediaQuery.sizeOf(context).height * 0.3,
                        child: Image.asset('assets/images/logo3.png'),
                      ),
                    ),
                  ),
                  _buildTextField(_firstNameController, 'First Name', 'Please enter your first name'),
                  _buildTextField(_lastNameController, 'Last Name', 'Please enter your last name'),
                  _buildPasswordField(),
                  _buildTextField(_emailController, 'Email', 'Please enter a valid email address',
                      keyboardType: TextInputType.emailAddress, validator: _emailValidator),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.black,))
                        : SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _createCustomer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text('Submit'),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Center(child: Text('Already have an account?login', style: TextStyle(color: Colors.green, fontSize: 18),))),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String? validationMessage, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        keyboardType: keyboardType,
        validator: validator ??
            (validationMessage != null
                ? (value) => value!.isEmpty ? validationMessage : null
                : null),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: _obscurePassword, // Toggles the visibility of the password
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword; // Toggle visibility
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a Password';
          }
          return null;
        },
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
