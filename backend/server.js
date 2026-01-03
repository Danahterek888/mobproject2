const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const mysql = require("mysql2");

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "mobileproject",
});

db.connect((err) => {
  if (err) {
    console.error("DB connection error:", err);
    return;
  }
  console.log("MySQL Connected...");
});

// GET ALL PRODUCTS
app.get("/api", (req, res) => {
  db.query("SELECT * FROM products", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
});

// VIEW CART
app.get("/api/cart", (req, res) => {
  const sql = `
    SELECT 
      cart.id,
      products.name,
      products.type,
      products.price,
      products.image_url
    FROM cart
    LEFT JOIN products ON cart.product_id = products.id
  `;

  db.query(sql, (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
});

// ADD TO CART
app.post("/api/cart", (req, res) => {
  const { product_id } = req.body;
  const sql = "INSERT INTO cart (product_id) VALUES (?)";

  db.query(sql, [product_id], (err, result) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Added to cart", result });
  });
});

// DELETE ONE ITEM
app.delete("/api/cart/:id", (req, res) => {
  const { id } = req.params;
  const sql = "DELETE FROM cart WHERE id = ?";

  db.query(sql, [id], (err, result) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Item removed", result });
  });
});

// CLEAR CART
app.delete("/api/cart", (req, res) => {
  db.query("DELETE FROM cart", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json({ message: "Cart cleared", result });
  });
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});
