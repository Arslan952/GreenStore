import 'package:flutter/material.dart';

class GlobalTextField extends StatefulWidget {
  final String name;
  final TextEditingController controller;
  const GlobalTextField({super.key, required this.name, required this.controller});

  @override
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Dispose controller when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "${widget.name}*",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8), // Add some spacing
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: "",
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0), // Adjust padding
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0), // Circular border
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
