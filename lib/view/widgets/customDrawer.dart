import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../user_authentication/auth_service_provider.dart';
import '../currentOrder.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.5,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children:  [
            SizedBox(height: 20,),
            DrawerItems(title:"Profile", icon: Icons.person, onTap:(){

            },),
            DrawerItems(title:"Orders", icon: Icons.fact_check_outlined, onTap:(){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrdersListScreen(),
                ),
              );
            },),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                return  DrawerItems(title:"LogOut", icon:Icons.logout_outlined, onTap:() async {
                  final provider =Provider.of<AuthServiceProvider>(context,listen: false);
                  await provider.clearToken(context);
                },);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItems extends StatelessWidget {
  String title;
  IconData icon;
  Function() onTap;
   DrawerItems({
    super.key,
    required this.title,
    required this.icon,required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
              Icon(icon),
              const SizedBox(width: 30,),
              Text(title,style: const TextStyle(fontSize: 15),)
            ],),
            const Divider(color: Colors.black,)
          ],
        ),
      ),
    );
  }
}
