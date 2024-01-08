//  child: Card(
//         child: ListTile(
//           leading: CircleAvatar(
//             backgroundImage: imageUrl.isNotEmpty
//                 ? NetworkImage(imageUrl)
//                 : AssetImage("images/employe.png") as ImageProvider,
//           ),
//           title: Text(name),
//           subtitle: Text('Employee ID: $sequentialId'),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               IconButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: const Text(
//                           'Confirm Edit',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         content:
//                             const Text('Do you want to edit this employee?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text(
//                               'Cancel',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       EditEmployee(documentId: documentId),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               'Edit',
//                               style: TextStyle(color: Colors.green),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 icon: const Icon(Icons.edit),
//               ),
//               IconButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: const Text(
//                           'Confirm Deletion',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         content: const Text(
//                             'Are you sure you want to delete this employee?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () async {
//                               try {
//                                 await FirebaseFirestore.instance
//                                     .collection('employees')
//                                     .doc(documentId)
//                                     .delete();

//                                 Navigator.pop(context);

//                                 Fluttertoast.showToast(
//                                     msg: 'Employe delete suchesfull');
//                               } catch (e) {
//                                 print("Error deleting employee: $e");
//                               }
//                             },
//                             child: const Text(
//                               'Yes',
//                               style: TextStyle(color: Colors.green),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: const Text(
//                               'No',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 icon: const Icon(
//                   Icons.delete,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),