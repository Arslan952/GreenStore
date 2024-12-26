import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_commerce/user_authentication/auth_service_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../constaints/media_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Map<String, dynamic> message; // Declare the variable without initializing
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () async {
      final provider = Provider.of<AuthServiceProvider>(context,listen: false);
        await provider.validateUser(context);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var allsize =
        MediaQuery.of(context).size.height + MediaQuery.of(context).size.width;
    final mq = MediaQuerySize(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(width: size.width * 0.8, 'assets/images/logo3.png'),
            SizedBox(
              height: size.height * 0.1,
            ),
            Center(
              child: LoadingAnimationWidget.inkDrop(
                  color: Colors.green, size: mq.total*0.0340),
            ),
          ],
        ),
      ),
    );
  }
}
