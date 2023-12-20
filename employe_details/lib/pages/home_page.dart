import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employe_details/pages/add_employe.dart';
import 'package:employe_details/pages/edit_employe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEmploye(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection("employes").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index].data();
                    final name = doc["name"] as String?;

                    return EmployeCard(name: name);
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class EmployeCard extends StatelessWidget {
  const EmployeCard({
    super.key,
    required this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(
            child: Image(image: AssetImage("images/employe.png")),
          ),
          title: Text(name ?? 'No name'),
          subtitle: const Text('id'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditEmploye(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class Employe extends StatelessWidget {
//   const Employe({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10, bottom: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.94,
//             height: 80,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10), color: Colors.white),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: CircleAvatar(
//                     backgroundImage: AssetImage('images/employe.png'),
//                     backgroundColor: Colors.red,
//                     radius: 30,
//                   ),
//                 ),
//                 const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Employe name : amal',
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                     ),
//                     Text(
//                       'Employe ID :',
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const EditEmploye(),
//                             ));
//                       },
//                       icon: const Icon(Icons.edit),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.delete,
//                         color: Colors.red,
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// body: ListView(
//   children: const [
//     Padding(
//       padding: EdgeInsets.only(left: 10, right: 10),
//       child: Column(
//         children: [
//           Employe(),
//           Employe(),
//         ],
//       ),
//     ),
//   ],
// ),

// Widget _buildUI() {
//   return SafeArea(
//       child: Column(
//     children: [_messageListView()],
//   ));
// }

// Widget _messageListView() {
//   return SizedBox(
//       height: MediaQuery.sizeOf(context).height * 0.80,
//       width: MediaQuery.sizeOf(context).width,
//       child: StreamBuilder(
//         stream: _databaseServieses.getEmployes(),
//         builder: (context, snapshot) {
//           List employ = snapshot.data?.docs ?? [];
//           if (employ.isEmpty) {
//             return const Center(
//               child: Text('Add a employe'),
//             );
//           }

//           return ListView.builder(
//             itemCount: employ.length,
//             itemBuilder: (context, index) {
//               Employe emply = employ[index].data();
//               String employeId = employ[index].id;
//               print(employeId);

//               return const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                 child: ListTile(),
//               );
//             },
//           );
//         },
//       ));
// }

// @override
// Widget build(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 10, bottom: 10),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width * 0.94,
//           height: 80,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10), color: Colors.white),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: CircleAvatar(
//                   backgroundImage: AssetImage('images/employe.png'),
//                   backgroundColor: Colors.red,
//                   radius: 30,
//                 ),
//               ),
//               const Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Employe name : amal',
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
//                   ),
//                   Text(
//                     'Employe ID :',
//                     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const EditEmploye(),
//                           ));
//                     },
//                     icon: const Icon(Icons.edit),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.delete,
//                       color: Colors.red,
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
