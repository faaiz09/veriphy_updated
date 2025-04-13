// lib/providers/product_provider.dart

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/models/product/product.dart';
import 'package:rm_veriphy/models/product/product_type.dart';
import 'package:rm_veriphy/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService;

  List<ProductType> _productTypes = [];
  List<Product> _products = [];
  List<dynamic> _documentList = [];
  bool _isLoading = false;
  String? _error;

  ProductProvider(this._productService);

  // Getters
  List<ProductType> get productTypes => _productTypes;
  List<Product> get products => _products;
  List<dynamic> get documentList => _documentList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProductTypes() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _productTypes = await _productService.getProductTypes();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProducts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _productService.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDocumentList() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _documentList = await _productService.getDocumentList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
