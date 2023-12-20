import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:image_picker/image_picker.dart';

class EditEmploye extends StatefulWidget {
  const EditEmploye({super.key});

  @override
  State<EditEmploye> createState() => _EditEmployeState();
}

class _EditEmployeState extends State<EditEmploye> {
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
        title: const Text('Edit Employe Details'),
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
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Employe Name'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Employee ID',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Designation',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Email'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: CSCPicker(
                      onCountryChanged: (country) {},
                      onStateChanged: (state) {},
                      onCityChanged: (city) {},
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(' Phone Number'),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Address'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(
                        const Size(double.infinity, 50),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
