// lib/providers/customer_provider.dart
// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:rm_veriphy/services/api_service.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';
import 'package:rm_veriphy/services/customer_process_service.dart';

class CustomerProvider with ChangeNotifier {
  final ApiService _apiService;
  final CustomerProcessService _processService;
  List<CustomerData> _customers = [];
  bool _isLoading = false;
  String? _error;

  CustomerProvider(this._apiService, this._processService); 

  List<CustomerData> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get error => _error;

 Future<void> initiateProcess(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _processService.initiateProcess(userId);
      await loadCustomers(); // Reload customer list to reflect changes
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> reinitiateProcess(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _processService.reinitiateProcess(userId);
      await loadCustomers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeProcess(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _processService.completeProcess(userId);
      await loadCustomers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetCustomer(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _processService.resetCustomer(userId);
      await loadCustomers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCustomerStage({
    required String userId,
    required String stageName,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _processService.editCustomer(
        userId: userId,
        stageName: stageName,
      );
      await loadCustomers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadCustomers() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('Loading customers...'); // Debug log
      final List<CustomerData> loadedCustomers =
          await _apiService.getCustomerList();
      print('Loaded ${loadedCustomers.length} customers'); // Debug log

      _customers = loadedCustomers;
    } catch (e) {
      print('Error loading customers: $e'); // Debug log
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> filterCustomers({
    String? productType,
    String? status,
    String? ageing,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('Filtering customers with:'); // Debug log
      print('Product Type: $productType'); // Debug log
      print('Status: $status'); // Debug log
      print('Ageing: $ageing'); // Debug log

      _customers = await _apiService.getFilteredCustomerList(
        productType: productType,
        status: status,
        ageing: ageing,
      );
    } catch (e) {
      print('Error filtering customers: $e'); // Debug log
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
