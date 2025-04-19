import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
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
    try {
      print('addProduct fun called');
      var index = _products.indexWhere((value) => value.name == product.name);

      if (index != -1) {
        var existingProduct = _products[index];
        _products[index] = Product(
          name: existingProduct.name,
          price: existingProduct.price,
          quantity: existingProduct.quantity + product.quantity,
        );
      } else {
        _products.add(product);
      }

      for (var i in _products) {
        print(i.name);
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void removeProduct(Product product) {
    try {
      print('removeProduct fun called');
      _products.remove(product);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
