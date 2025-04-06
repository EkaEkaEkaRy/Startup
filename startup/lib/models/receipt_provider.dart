import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup/models/product_model.dart';

class ReceiptProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  double get totalSum => _products.fold(
      0.0, (sum, product) => sum + product.price * product.quantity);

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _products.remove(product);
    notifyListeners();
  }
}
