import 'package:flutter/material.dart';
import 'package:green_commerce/user_authentication/auth_service_provider.dart';
import 'package:green_commerce/view/createCustomer.dart';
import 'package:green_commerce/view/home_screen.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../../function.dart';
import 'cliper_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isRemembered = false;
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  Future<void> _login() async {
    print('hello login ');
    bool isConnected = await FunctionClass().isInternetConnected();
    final provider = Provider.of<AuthServiceProvider>(context, listen: false);
    final form = _loginFormKey.currentState;
    if (!isConnected) {
      MotionToast.error(
        title:  const Text("Failed"),
        description:  const Text("Internet not connected"),
      ).show(context);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       'Internet not connected',
      //       style: TextStyle(color: Colors.red),
      //     ),
      //     backgroundColor: Colors.white,
      //   ),
      // );
      return;
    }
    if (form!.validate()) {
      provider.authenticateUser(
          emailController.text, passwordController.text, context);
      if (isRemembered) {
        provider.saveCredentials(emailController.text, passwordController.text);
      }
    }
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
        child: Consumer<AuthServiceProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            return Form(
              key: _loginFormKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      width: MediaQuery.sizeOf(context).height * 0.4,
                      child: Image.asset(
                          fit: BoxFit.cover, 'assets/images/logo3.png'),
                    ),
                  ),
                  // _buildSocialLogins(),
                  _buildInputFields(provider)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputFields(AuthServiceProvider provider) {
    return ClipPath(
      // clipper: CustomClipperWidget(),
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50), topLeft: Radius.circular(50)),
            color: Colors.green
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.green,
            //     Color.fromARGB(100, 40, 50, 100),
            //   ],
            //   begin: Alignment.topRight,
            //   end: Alignment.topLeft,
            // )
            ),
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
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Remember me',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isRemembered = !isRemembered;
                        });
                      },
                      icon: Icon(
                        isRemembered
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              provider.isLoading == false
                  ? SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          _login();
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text('Login',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ),
                    )
                  // InkWell(
                  //       onTap: (){
                  //            _login();
                  //           // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  //       },
                  //       child: Container(
                  //         width: 100,
                  //         height: 40,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           // border: Border.all(color: Colors.brown,width: 2),
                  //           borderRadius: BorderRadius.circular(20)
                  //         ),
                  //         child: const Center(child: Text('LOGIN', style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                  //       ),
                  //     )
                  : const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
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
              ),
              // const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateCustomerScreen()));
                },
                child: const Text(
                  "Don't Have an Account. Register?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
