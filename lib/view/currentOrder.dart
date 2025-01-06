import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/response/order.dart';
import 'package:woosignal/woosignal.dart';

import '../models/auth_model.dart';
import '../user_authentication/auth_service_provider.dart';

class OrdersListScreen extends StatefulWidget {
  const OrdersListScreen({Key? key}) : super(key: key);

  @override
  State<OrdersListScreen> createState() => _OrdersListScreenState();
}

class _OrdersListScreenState extends State<OrdersListScreen> {
  List<Order> orders = [];
  bool isLoading = false;

  Future<void> _getOrders() async {
    try {
      setState(() {
        isLoading = true;
      });
      AuthResponse? authResponse = await Provider.of<AuthServiceProvider>(context, listen: false).retrieveAuthResponse();
      int userId = 0;
      if (authResponse != null) {
        userId = authResponse.userId;
      }
      List<Order> order = await WooSignal.instance.getOrders(customer: userId);
      setState(() {
        orders = order ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error initializing WooSignal: $e");
    }
  }

  @override
  void initState() {
    _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Current Orders",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.black),
      )
          : orders.isNotEmpty
          ? ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${order.id}",
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Status: ${order.status ?? 'N/A'}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Total: ${order.currency} ${order.total ?? '0.00'}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(order: order),
                        ),
                      );
                    },
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          'No Orders Found',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "processing":
        return Colors.blue;
      case "on-hold":
        return Colors.amber;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "refunded":
        return Colors.purple;
      case "failed":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}


class OrderDetailsScreen extends StatelessWidget {
  final Order order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order #${order.id ?? 'N/A'}',
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RowWidget(title: "Order ID", data: order.id?.toString() ?? 'N/A'),
              const SizedBox(height: 8.0),
              RowWidget(title: "Status", data: order.status ?? 'N/A'),
              const SizedBox(height: 8.0),
              RowWidget(
                title: "Total",
                data: '${order.currency ?? ''} ${order.total ?? '0.00'}',
              ),
              const SizedBox(height: 15),
              if (order.billing != null)
                _buildAddressSection(
                  title: "Billing",
                  name: '${order.billing!.firstName ?? ''} ${order.billing!.lastName ?? ''}',
                  address: '${order.billing!.address1 ?? ''}\n${order.billing!.city ?? ''}\n${order.billing!.postcode ?? ''}',
                  email: order.billing!.email ?? 'N/A',
                  phone: order.billing!.phone ?? 'N/A',
                ),
              const SizedBox(height: 15),
              if (order.shipping != null)
                _buildAddressSection(
                  title: "Shipping",
                  name: '${order.shipping!.firstName ?? ''} ${order.shipping!.lastName ?? ''}',
                  address: '${order.shipping!.address1 ?? ''}\n${order.shipping!.city ?? ''}\n${order.shipping!.postcode ?? ''}',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressSection({
    required String title,
    required String name,
    required String address,
    String? email,
    String? phone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black54,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.isNotEmpty ? name : 'N/A'),
                Text(address.isNotEmpty ? address : 'N/A'),
                const SizedBox(height: 10),
                if (email != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(email),
                    ],
                  ),
                if (phone != null)
                  const SizedBox(height: 10),
                if (phone != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Phone",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(phone),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RowWidget extends StatelessWidget {
  final String title;
  final String data;

  const RowWidget({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(data.isNotEmpty ? data : 'N/A'),
        ],
      ),
    );
  }
}


