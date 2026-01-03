import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewPage extends StatefulWidget {
  final int id;
  final String title;
  final String price;
  final String image;

  NewPage({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.image,
  }) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  String selectedDegree = "-2.5";
  int quantity = 1;
  String lensMaterial = "Plastic";

  final List<String> degrees = [
    "-1.0",
    "-1.5",
    "-2.0",
    "-2.5",
    "-3.0",
    "-3.5",
    "-4.0",
  ];

  double get totalPrice =>
      (double.tryParse(widget.price) ?? 0.0) * quantity;

  Future<void> addToCart() async {
    try {
      final response = await http.post(
        Uri.parse("https://mobproject2.up.railway.app/api/cart"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "product_id": widget.id,
          "quantity": quantity,
          "degree": selectedDegree,
          "material": lensMaterial,
          "product_name": widget.title,
          "price": widget.price,
          "image": widget.image,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added $quantity x ${widget.title} to cart")),
        );
      } else {
        print("Add to cart failed: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add to cart")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error connecting to server")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFF4B3351),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD8EA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: const Color(0xFFFFF6F3),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.image,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B3351),
                ),
              ),
              const SizedBox(height: 30),
              _buildDropdown(
                label: "Choose Degree",
                value: selectedDegree,
                items: degrees,
                onChanged: (val) => setState(() => selectedDegree = val!),
              ),
              const SizedBox(height: 20),
              const Text(
                "Lens Material",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B3351),
                ),
              ),
              Column(
                children: [
                  RadioListTile<String>(
                    title: const Text("Plastic"),
                    activeColor: const Color(0xFFB97A95),
                    value: "Plastic",
                    groupValue: lensMaterial,
                    onChanged: (val) => setState(() => lensMaterial = val!),
                  ),
                  RadioListTile<String>(
                    title: const Text("Glass"),
                    activeColor: const Color(0xFFB97A95),
                    value: "Glass",
                    groupValue: lensMaterial,
                    onChanged: (val) => setState(() => lensMaterial = val!),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Color(0xFFB97A95)),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B3351),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFFB97A95)),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB97A95),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                onPressed: addToCart,
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB97A95)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: const TextStyle(color: Color(0xFF4B3351))),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
