// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:image_picker/image_picker.dart';

typedef UpdateCallback = Function(String value, String id);

class AddEmploye extends StatefulWidget {
  const AddEmploye({Key? key}) : super(key: key);

  @override
  State<AddEmploye> createState() => _AddEmployeState();
}

class _AddEmployeState extends State<AddEmploye> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _selectImage() async {
    XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(
        () {
          _image = pickedImage;
        },
      
      );
    }
  }

  final TextEditingController _name = TextEditingController();
  final TextEditingController _adress = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _designation = TextEditingController();
  final TextEditingController _number = TextEditingController();
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  final CollectionReference _addEmploye =
      FirebaseFirestore.instance.collection("employes");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_backspace,
            size: 30,
          ),
        ),
        title: const Text('Add Employee Details'),
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
                controller: _name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Employee Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _designation,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Designation',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
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
              child: TextField(
                controller: _number,
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
                controller: _adress,
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
                onPressed: () async {
                  final String name = _name.text;
                  final String address = _adress.text;
                  final String designation = _designation.text;
                  final String email = _email.text;
                  final String phoneNumber = _number.text;

                  if (address.isNotEmpty) {
                    const String commonId = 'common_id_for_all_employees';

                    final DocumentReference employeeRef =
                        _addEmploye.doc(commonId);

                    await employeeRef.set({
                      "name": name,
                      "address": address,
                      "designation": designation,
                      "email": email,
                      "country": countryValue,
                      "city": cityValue,
                      "state": stateValue,
                      "phone number": phoneNumber,
                    });

                    _name.text = '';
                    _adress.text = '';
                    _designation.text = '';
                    _email.text = '';
                    _number.text = '';

                    Navigator.of(context).pop();
                  }
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
