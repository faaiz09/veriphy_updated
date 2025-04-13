// lib/services/product_service.dart

import 'package:dio/dio.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/models/product/product.dart';
import 'package:rm_veriphy/models/product/product_type.dart';
import 'package:rm_veriphy/utils/token_manager.dart';

class ProductService {
  final Dio _dio;

  ProductService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) => status! < 500,
    );
  }

  Future<List<ProductType>> getProductTypes() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.productTypeList,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> types = response.data['productTypes'] ?? [];
        return types.map((json) => ProductType.fromJson(json)).toList();
      }

      throw Exception(
          response.data['message'] ?? 'Failed to get product types');
    } catch (e) {
      throw Exception('Failed to get product types: $e');
    }
  }

  Future<List<Product>> getProducts() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.productList,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final List<dynamic> products = response.data['products'] ?? [];
        return products.map((json) => Product.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to get products');
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  Future<List<dynamic>> getDocumentList() async {
    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.post(
        ApiConstants.documentList,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['documents'] ?? [];
      }

      throw Exception(
          response.data['message'] ?? 'Failed to get document list');
    } catch (e) {
      throw Exception('Failed to get document list: $e');
    }
  }
}
