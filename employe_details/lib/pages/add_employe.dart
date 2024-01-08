// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _selectImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _number = TextEditingController();
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String? _selectedGender;

  final CollectionReference _addEmployee =
      FirebaseFirestore.instance.collection("employees");

  Future<String?> uploadImageToFirebase(XFile imageFile) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('employee_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(File(imageFile.path));
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image to Firebase Storage: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _selectImage,
                  child: _image != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(File(_image!.path)),
                        )
                      : const CircleAvatar(
                          radius: 50,
                          child: Icon(Icons.person),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Employee Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Gender',
                  ),
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _designation,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Designation',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter designation';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    } else if (!value.toLowerCase().endsWith('.com')) {
                      return 'Email should end with .com';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: CSCPicker(
                        onCountryChanged: (country) {
                          setState(() {
                            countryValue = country;
                          });
                        },
                        onStateChanged: (state) {
                          setState(() {
                            stateValue = state;
                          });
                        },
                        onCityChanged: (city) {
                          cityValue = city;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _number,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    } else if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Only numeric values are allowed';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _address,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter adress';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await addEmployeeToFirestore();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10)),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 20)),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addEmployeeToFirestore() async {
    try {
      String docId = _addEmployee.doc().id;
      final String name = _name.text;
      final String address = _address.text;
      final String designation = _designation.text;
      final String email = _email.text;
      final String phoneNumber = _number.text;
      String? imageUrl;

      if (_image != null) {
        imageUrl = await uploadImageToFirebase(_image!);
      }
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await _addEmployee.doc(docId).set(
        {
          "id": docId,
          "name": name,
          "address": address,
          "designation": designation,
          "email": email,
          "phone number": phoneNumber,
          "image_url": imageUrl,
          "gender": _selectedGender,
          "timestamp": formattedDate,
          "country": countryValue,
          "state": stateValue,
          "city": cityValue,
        },
      );

      _name.clear();
      _address.clear();
      _designation.clear();
      _email.clear();
      _number.clear();

      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Employee added successfully');
    } catch (e) {
      print("Error adding employee: $e");
      Fluttertoast.showToast(msg: 'Failed to add employee');
    }
  }
}
