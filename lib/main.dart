import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFormPage(),
      routes: {
        '/userInfo': (context) => UserInfoPage(),
      },
    );
  }
}

class MyFormPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Validation Example'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: 'Enter your first name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: 'Enter your last name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Enter your phone number',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                LengthLimitingTextInputFormatter(11),
              ],
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !RegExp(r'^(\+7|8)\d{10}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(context, '/userInfo', arguments: {
                      'firstName': _firstNameController.text,
                      'lastName': _lastNameController.text,
                      'phoneNumber': _phoneController.text,
                      'email': _emailController.text,
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, String> userData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User: ${userData['firstName']} ${userData['lastName']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Cell Phone: ${userData['phoneNumber']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${userData['email']}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
