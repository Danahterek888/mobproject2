import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];

  final String baseUrl = "http://127.0.0.1:5000";

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    final response = await http.get(Uri.parse("$baseUrl/api/cart"));
    if (response.statusCode == 200) {
      setState(() {
        cartItems = json.decode(response.body);
      });
    }
  }

  Future<void> removeItem(int id) async {
    final response =
        await http.delete(Uri.parse("$baseUrl/api/cart/$id"));

    if (response.statusCode == 200) {
      setState(() {
        cartItems.removeWhere((item) => item["id"] == id);
      });
    }
  }

  Future<void> clearCart() async {
    final response =
        await http.delete(Uri.parse("$baseUrl/api/cart"));

    if (response.statusCode == 200) {
      setState(() {
        cartItems.clear();
      });
    }
  }

  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      final price =
          double.tryParse(item["price"]?.toString() ?? "0") ?? 0;
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping Cart"),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD8EA),
      ),
      backgroundColor: const Color(0xFFFFF6F3),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),

                          // ✅ FIXED leading widget
                          leading: SizedBox(
                            width: 60,
                            height: 60,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: item["image_url"] != null
                                  ? Image.network(
                                      item["image_url"],
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                  : const Icon(Icons.image),
                            ),
                          ),

                          title: Text(
                            item["name"] ?? "Unknown",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Type: ${item["type"] ?? "N/A"}\nPrice: \$${item["price"]}",
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min, // ✅ FIX
                            children: [
                                Text(
                                    "\$${item["price"]}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    IconButton(
                                        padding: EdgeInsets.zero, // ✅ removes extra space
                                        constraints: const BoxConstraints(), // ✅ removes default size
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => removeItem(item["id"]),
                                        ),
                                    ],
                                    ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: clearCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[200],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                        ),
                        child: const Text("Confirm Purchase"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
