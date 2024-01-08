// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, prefer_const_constructors_in_immutables, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employe_details/pages/add_employe.dart';
import 'package:employe_details/pages/employe_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      appBar: GradientAppBar(
        title: 'Employee Details',
        onLogout: () {
          // Implement your logout logic here
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmployee(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("employees")
              .orderBy(
                "timestamp",
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No employees found."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final name = doc.data()["name"] as String?;
                final documentId = (index + 1).toString();
                final imageUrl = doc.data()["image_url"] as String? ?? '';

                return EmployeCard(
                  name: name ?? 'No name',
                  sequentialId: documentId,
                  documentId: doc.id,
                  imageUrl: imageUrl,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class EmployeCard extends StatelessWidget {
  const EmployeCard({
    Key? key,
    required this.name,
    required this.sequentialId,
    required this.documentId,
    required this.imageUrl,
  }) : super(key: key);

  final String name;
  final String sequentialId;
  final String documentId;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEmployeeDetails(documentId: documentId),
            ));
      },
      child: _EmployeCard(
          imageUrl: imageUrl,
          name: name,
          sequentialId: sequentialId,
          documentId: documentId),
    );
  }
}

class _EmployeCard extends StatelessWidget {
  const _EmployeCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.sequentialId,
    required this.documentId,
  });

  final String imageUrl;
  final String name;
  final String sequentialId;
  final String documentId;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueGrey,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : AssetImage("images/employe.png") as ImageProvider,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          'Employee ID: $sequentialId',
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onLogout;

  GradientAppBar({
    Key? key,
    required this.title,
    required this.onLogout,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [Colors.blue, Colors.purple, Colors.red],
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Confirm Logout',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: 'Logout successful');
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.logout, color: Colors.white),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}
