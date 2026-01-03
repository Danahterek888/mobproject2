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

  // ✅ safer price parsing
  double get totalPrice =>
      (double.tryParse(widget.price) ?? 0.0) * quantity;

  Future<void> addToCart() async {
    final response = await http.post(
      Uri.parse("http://localhost:5000/api/cart"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "product_id": widget.id,
        "quantity": quantity,
        "degree": selectedDegree,
        "material": lensMaterial,
        // include these only if your backend schema supports them:
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
        SnackBar(content: Text("Failed to add to cart")),
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
          style: TextStyle(
            color: Color(0xFF4B3351),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFD8EA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: Color(0xFFFFF6F3),
      body: Padding(
        padding: EdgeInsets.all(24.0),
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
              SizedBox(height: 20),
              Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B3351),
                ),
              ),
              SizedBox(height: 30),
              _buildDropdown(
                label: "Choose Degree",
                value: selectedDegree,
                items: degrees,
                onChanged: (val) => setState(() => selectedDegree = val!),
              ),
              SizedBox(height: 20),
              Text(
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
                    title: Text("Plastic"),
                    activeColor: Color(0xFFB97A95),
                    value: "Plastic",
                    groupValue: lensMaterial,
                    onChanged: (val) => setState(() => lensMaterial = val!),
                  ),
                  RadioListTile<String>(
                    title: Text("Glass"),
                    activeColor: Color(0xFFB97A95),
                    value: "Glass",
                    groupValue: lensMaterial,
                    onChanged: (val) => setState(() => lensMaterial = val!),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle, color: Color(0xFFB97A95)),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text(
                    "$quantity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4B3351),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, color: Color(0xFFB97A95)),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB97A95),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                onPressed: addToCart,
                child: Text(
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFFFBFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFB97A95)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: TextStyle(color: Color(0xFF4B3351))),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
