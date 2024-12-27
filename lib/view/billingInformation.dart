import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woosignal/models/payload/order_wc.dart';
import '../function.dart';
import '../models/cart_model.dart';
import '../provider/all_app_provider.dart'; // Import your order creation function

class BillingDetailsScreen extends StatefulWidget {
  final List<CartItem> cartData;

  BillingDetailsScreen({required this.cartData});

  @override
  _BillingDetailsScreenState createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _orderNotesController = TextEditingController();

  // Country and State dropdown values
  String _selectedCountry = 'Pakistan';
  String _selectedState = 'Punjab';

  // List of countries and states (can be expanded)
  final List<String> _countries = ['Pakistan', 'India', 'USA', 'UK'];
  final List<String> _states = ['Punjab', 'Sindh', 'Khyber Pakhtunkhwa', 'Balochistan'];

  bool isLoading=false;

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {

      // Create Billing and Shipping objects from form data
      Billing billingDetails = Billing(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        company: _companyNameController.text,
        address1: _streetAddressController.text,
        address2: '',
        city: _cityController.text,
        state: _selectedState,
        postcode: _postcodeController.text,
        country: _selectedCountry,
        email: _emailController.text,
        phone: _phoneController.text,
      );

      Shipping shippingDetails = Shipping(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        address1: _streetAddressController.text,
        address2: '',
        city: _cityController.text,
        state: _selectedState,
        postcode: _postcodeController.text,
        country: _selectedCountry,
      );

      // Call the order creation function
      FunctionClass().createAndSendOrder(context, widget.cartData, billingDetails, shippingDetails);

    }
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyNameController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _orderNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Billing Detail", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(_firstNameController, 'First name', 'Please enter your first name'),
                _buildTextField(_lastNameController, 'Last name', 'Please enter your last name'),
                _buildTextField(_companyNameController, 'Company name (optional)', null),
                _buildDropdownField('Country / Region', _selectedCountry, _countries, (value) {
                  setState(() => _selectedCountry = value!);
                }),
                _buildTextField(_streetAddressController, 'Street address', 'Please enter your street address'),
                _buildTextField(_cityController, 'Town / City', 'Please enter your city'),
                _buildDropdownField('State / County', _selectedState, _states, (value) {
                  setState(() => _selectedState = value!);
                }),
                _buildTextField(_postcodeController, 'Postcode / ZIP', 'Please enter your postcode'),
                _buildTextField(_phoneController, 'Phone', 'Please enter your phone number', validator: _phoneValidator),
                _buildTextField(_emailController, 'Email address', 'Please enter a valid email', keyboardType: TextInputType.emailAddress, validator: _emailValidator),
                _buildTextField(_orderNotesController, 'Order notes (optional)', null, maxLines: 3),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child:
                  Consumer<AllAppProvider>(
                    builder: (BuildContext context, allProvider,
                        Widget? child) {
                      return  allProvider.isOrdercreating==true?
                          const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ):
                        SizedBox(
                        width: double.infinity,
                        height: 50.0, // Set height to 100 pixels
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, // Set button color to green
                          ),
                          child: Text('Submit'),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
        int maxLines = 1,
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
        maxLines: maxLines,
        validator: validator ??
            (validationMessage != null
                ? (value) => value!.isEmpty ? validationMessage : null
                : null),
      ),
    );
  }

  Widget _buildDropdownField(
      String label,
      String value,
      List<String> items,
      ValueChanged<String?> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  // Email validation function
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

  // Phone validation function
  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r"^[0-9]{10}$");
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }
}
