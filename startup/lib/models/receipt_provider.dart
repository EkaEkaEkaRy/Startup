import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:startup/models/product_model.dart';

class ReceiptProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  double get totalSum => _products.fold(
      0.0, (sum, product) => sum + product.price * product.quantity);

  void initProduct(List<Product> products) {
    _products = products;
  }

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    try {
      print('removeProduct fun called');
      _products.remove(product);
      for (var i in products) {
        print(i.name);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
