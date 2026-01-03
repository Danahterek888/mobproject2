// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'newPage.dart';
// import 'cart.dart';
// import 'contactus.dart'; // ✅ NEW import

// class ListViewDemo extends StatefulWidget {
//   const ListViewDemo({Key? key}) : super(key: key);

//   @override
//   State<ListViewDemo> createState() => _ListViewDemoState();
// }

// class _ListViewDemoState extends State<ListViewDemo> {
//   List<dynamic> data = [];

//   final String baseUrl = "http://127.0.0.1:5000"; // ✅ web-safe

//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }

//   Future<void> fetchProducts() async {
//     final response = await http.get(Uri.parse("$baseUrl/api"));
//     if (response.statusCode == 200) {
//       setState(() {
//         data = json.decode(response.body);
//       });
//     } else {
//       debugPrint("Failed to load products");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 4,
//         title: const Text(
//           'Our Products',
//           style: TextStyle(
//             color: Color(0xFF4B3351),
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//             letterSpacing: 1.2,
//           ),
//         ),
//         backgroundColor: const Color(0xFFFFD8EA),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//         ),
//         actions: [
//           // ☰ Menu
//           IconButton(
//             icon: const Icon(Icons.menu, color: Color(0xFF4B3351)),
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Menu clicked!"),
//                   backgroundColor: Color(0xFFB97A95),
//                 ),
//               );
//             },
//           ),

//           // 💬 Message → Contact Us
//           IconButton(
//             icon: const Icon(Icons.message, color: Color(0xFF4B3351)),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ContactUs(),
//                 ),
//               );
//             },
//           ),

//           // 🛒 Cart
//           IconButton(
//             icon: const Icon(Icons.shopping_cart, color: Color(0xFF4B3351)),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const CartPage(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       backgroundColor: const Color(0xFFFFF6F3),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           String? sectionTitle;

//           if (index == 0 || data[index]["type"] != data[index - 1]["type"]) {
//             sectionTitle = data[index]["type"];
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (sectionTitle != null)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 8),
//                   child: Text(
//                     sectionTitle!,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF4B3351),
//                     ),
//                   ),
//                 ),
//               Card(
//                 elevation: 6,
//                 shadowColor: Colors.pinkAccent.withOpacity(0.2),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 color: const Color(0xFFFFFBFA),
//                 child: ListTile(
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   leading: SizedBox(
//                     width: 50,
//                     height: 50,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(
//                         data[index]["image_url"] ?? "",
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(
//                             Icons.broken_image,
//                             color: Colors.grey,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   title: Text(
//                     data[index]["name"] ?? "",
//                     style: const TextStyle(
//                       color: Color(0xFF4B3351),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   subtitle: Text(
//                     "Price: \$${data[index]["price"]}",
//                     style: const TextStyle(
//                       color: Color(0xFFB97A95),
//                       fontSize: 14,
//                     ),
//                   ),
//                   trailing: const Icon(
//                     Icons.arrow_forward_ios,
//                     color: Color(0xFFB97A95),
//                     size: 18,
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => NewPage(
//                           id: data[index]["id"],
//                           title: data[index]["name"] ?? "",
//                           price: data[index]["price"].toString(),
//                           image: data[index]["image_url"] ?? "",
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'newPage.dart';
import 'cart.dart';
import 'contactus.dart'; // ✅ NEW import

class ListViewDemo extends StatefulWidget {
  const ListViewDemo({Key? key}) : super(key: key);

  @override
  State<ListViewDemo> createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  List<dynamic> data = [];

  // ✅ Use Railway backend URL instead of localhost
  final String baseUrl = "https://mobproject2.up.railway.app";

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api"));
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
        });
      } else {
        debugPrint("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          'Our Products',
          style: TextStyle(
            color: Color(0xFF4B3351),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: const Color(0xFFFFD8EA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          // ☰ Menu
          IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF4B3351)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Menu clicked!"),
                  backgroundColor: Color(0xFFB97A95),
                ),
              );
            },
          ),

          // 💬 Message → Contact Us
          IconButton(
            icon: const Icon(Icons.message, color: Color(0xFF4B3351)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactUs(),
                ),
              );
            },
          ),

          // 🛒 Cart
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFF4B3351)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFF6F3),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        itemBuilder: (context, index) {
          String? sectionTitle;

          if (index == 0 || data[index]["type"] != data[index - 1]["type"]) {
            sectionTitle = data[index]["type"];
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sectionTitle != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    sectionTitle!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B3351),
                    ),
                  ),
                ),
              Card(
                elevation: 6,
                shadowColor: Colors.pinkAccent.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: const Color(0xFFFFFBFA),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data[index]["image_url"] ?? "",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    data[index]["name"] ?? "",
                    style: const TextStyle(
                      color: Color(0xFF4B3351),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    "Price: \$${data[index]["price"]}",
                    style: const TextStyle(
                      color: Color(0xFFB97A95),
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFB97A95),
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewPage(
                          id: data[index]["id"],
                          title: data[index]["name"] ?? "",
                          price: data[index]["price"].toString(),
                          image: data[index]["image_url"] ?? "",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
