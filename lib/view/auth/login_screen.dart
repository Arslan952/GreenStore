import 'package:flutter/material.dart';
import 'package:green_commerce/user_authentication/auth_service_provider.dart';
import 'package:green_commerce/view/home_screen.dart';
import 'package:provider/provider.dart';

import 'cliper_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                width:MediaQuery.sizeOf(context).height * 0.4 ,
                child: Image.asset(
                   fit: BoxFit.cover,
                    'assets/images/logo.png'),
              ),
            ),
            // _buildSocialLogins(),
            _buildInputFields()
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    return ClipPath(
      // clipper: CustomClipperWidget(),
      child: Container(
        decoration: const BoxDecoration(
           borderRadius: BorderRadius.only( topRight: Radius.circular(50),topLeft:Radius.circular(50) ),
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Color.fromARGB(100, 40, 50, 100),
              ],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            )),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              const Text(
                "Sign in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 60),
              _buildTextField(emailController, Icons.person_outline, "Email"),
              const SizedBox(height: 20),
              _buildTextField(
                  passwordController, Icons.info_outline, "Password",
                  isPassword: true),
              const SizedBox(height: 40),

              InkWell(
                onTap: (){
                     final provider  = Provider.of<AuthServiceProvider>(context, listen:false);
                      provider.authenticateUser(emailController.text, passwordController.text,context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Center(child: Text('LOGIN', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        const Text(
          "Or sign in with",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/google.png"),
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/facebook.png"),
                iconSize: 60,
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset("assets/images/twitter.png"),
                iconSize: 60,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hint,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: const OutlineInputBorder(borderSide: BorderSide.none),

      ),
      obscureText: isPassword,
    );
  }
}
