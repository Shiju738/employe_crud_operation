// ignore_for_file: avoid_print, use_build_context_synchronously, unused_field

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditEmployee extends StatefulWidget {
  final String documentId;

  const EditEmployee({Key? key, required this.documentId}) : super(key: key);

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  @override
  void initState() {
    super.initState();

    fetchEmployeeDetails();
  }

  Future<void> fetchEmployeeDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("employes")
          .doc(widget.documentId)
          .get();

      setState(() {
        _nameController.text = snapshot.data()?["name"] ?? "";
        _designationController.text = snapshot.data()?["designation"] ?? "";
        _emailController.text = snapshot.data()?["email"] ?? "";
        _numberController.text = snapshot.data()?["phone number"] ?? "";
        _addressController.text = snapshot.data()?["address"] ?? "";
      });
    } catch (e) {
      print("Error fetching employee details: $e");
    }
  }

  Future<void> _selectImage() async {}

  Future<void> updateEmployeeDetails() async {
    try {
      final String name = _nameController.text;
      final String designation = _designationController.text;
      final String email = _emailController.text;
      final String phoneNumber = _numberController.text;
      final String address = _addressController.text;

      if (address.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("employes")
            .doc(widget.documentId)
            .update({
          "name": name,
          "designation": designation,
          "email": email,
          "phone number": phoneNumber,
          "address": address,
        });

        _nameController.clear();
        _designationController.clear();
        _emailController.clear();
        _numberController.clear();
        _addressController.clear();

        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error updating employee details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            size: 30,
            color: Colors.red,
          ),
        ),
        title: const Text(
          'Update details',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(File(_image!.path)),
                          )
                        : const CircleAvatar(
                            backgroundImage: AssetImage('images/employe.png'),
                            radius: 40,
                          ),
                    Positioned(
                      left: 40,
                      bottom: -16,
                      child: IconButton(
                        onPressed: _selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                          size: 19,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Employee Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _designationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Designation',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: updateEmployeeDetails,
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  "Update Employee",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
