// lib/services/api_service.dart
// ignore_for_file: unnecessary_cast, avoid_print, unnecessary_null_comparison

import 'package:dio/dio.dart';
import 'package:rm_veriphy/models/user.dart';
import 'package:rm_veriphy/constants/api_constants.dart';
import 'package:rm_veriphy/models/responses/auth_response.dart';
import 'package:rm_veriphy/models/dashboard/dashboard_data.dart';
import 'package:rm_veriphy/models/customer/customer_data.dart';
import 'package:rm_veriphy/models/document/document_info.dart';
import 'package:rm_veriphy/utils/token_manager.dart';
import 'package:rm_veriphy/services/connectivity_service.dart';

class ApiService {
  final Dio _dio;
  final ConnectivityService _connectivityService = ConnectivityService();

  ApiService() : _dio = Dio() {
    _initializeDio();
  }

  Dio get dio => _dio;

  void _initializeDio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    );
    _setupInterceptors();
  }

  Future<void> _checkConnectivity() async {
    if (!await _connectivityService.hasInternetConnection()) {
      throw Exception(
          'No internet connection. Please check your network settings.');
    }
  }

  void _setupInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            await _checkConnectivity();
            print('Making request to: ${options.uri}');

            // For login request
            if (options.path.contains('login')) {
              options.headers = {
                'Accept': '*/*',
                'Content-Type': 'application/json',
              };
              return handler.next(options);
            }

            // For other authenticated requests
            final token = await TokenManager.getToken();
            if (token == null || token.isEmpty) {
              return handler.reject(
                DioException(
                  requestOptions: options,
                  error: 'No authentication token found',
                ),
              );
            }

            // Set only Authorization header for authenticated requests
            options.headers = {'Authorization': 'Bearer $token'};

            print('Request headers: ${options.headers}');
            return handler.next(options);
          } catch (e) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: e.toString(),
              ),
            );
          }
        },
        onResponse: (response, handler) {
          print('Response status: ${response.statusCode}');
          print('Response data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          print('Request error: ${e.message}');
          print('Error response: ${e.response?.data}');

          if (e.type == DioExceptionType.badResponse &&
              e.response?.statusCode == 401) {
            await TokenManager.deleteToken();
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<AuthResponse> login(String email, String password) async {
    try {
      await _checkConnectivity();

      var dio = Dio();
      var response = await dio.request(
        ApiConstants.getFullUrl(ApiConstants.login),
        options: Options(
          method: 'POST',
          validateStatus: (_) => true,
        ),
        queryParameters: {
          'email': email,
          'password': password,
        },
      );

      print('Login Response: ${response.data}');

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final authResponse = AuthResponse.fromJson(response.data);
        if (authResponse.token != null && authResponse.token!.isNotEmpty) {
          await TokenManager.saveToken(authResponse.token!);
          final savedToken = await TokenManager.getToken();
          if (savedToken != authResponse.token) {
            throw Exception('Token verification failed');
          }
          print('Token saved successfully');
        }
        return authResponse;
      }

      throw Exception(response.data['message'] ?? 'Login failed');
    } on DioException catch (e) {
      print('Login DioError: ${e.message}');
      print('DioError type: ${e.type}');
      print('DioError response: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<User> authenticate() async {
    try {
      await _checkConnectivity();

      final token = await TokenManager.getToken();
      print('Using token for authentication: $token');

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      // Headers exactly as in working example
      var headers = {'Authorization': 'Bearer $token'};

      print('Request headers: $headers');
      print(
          'Request URL: ${ApiConstants.getFullUrl(ApiConstants.authenticate)}');

      // Create request exactly as in working example
      var dio = Dio();
      var response = await dio.request(
        ApiConstants.getFullUrl(ApiConstants.authenticate),
        options: Options(
          method: 'POST',
          headers: headers,
          validateStatus: (_) => true,
          followRedirects: false,
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data['status'] == 'success' &&
            response.data['user'] != null) {
          print('Authentication successful');
          return User.fromJson(response.data['user']);
        } else {
          print(
              'Authentication failed with message: ${response.data['message']}');
          throw Exception(response.data['message'] ?? 'Authentication failed');
        }
      } else {
        print('Authentication failed with status code: ${response.statusCode}');
        throw Exception(
            response.statusMessage ?? 'Authentication request failed');
      }
    } on DioException catch (e) {
      print('Authentication DioError: ${e.message}');
      print('DioError type: ${e.type}');
      print('DioError response: ${e.response?.data}');
      throw _handleError(e);
    } catch (e) {
      print('Authentication error: $e');
      throw Exception('Authentication failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      final token = await TokenManager.getToken();
      if (token != null) {
        await _dio.post(
          ApiConstants.logout,
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }),
        );
      }
    } on DioException catch (e) {
      print('Logout DioError: $e');
      throw _handleError(e);
    } catch (e) {
      print('Logout error: $e');
    } finally {
      await TokenManager.deleteToken();
    }
  }

  // Dashboard APIs
  Future<DashboardData> getDashboardData() async {
    try {
      await _checkConnectivity();

      print('Fetching dashboard data...'); // Debug log

      final response = await _dio.post(ApiConstants.dashboard);

      print('Dashboard API Response: ${response.data}'); // Debug log

      if (response.data == null) {
        throw Exception('No data received from dashboard API');
      }

      // Try to parse the response data
      try {
        final dashboardData = DashboardData.fromJson(response.data);
        print('Parsed Dashboard Data: $dashboardData'); // Debug log
        return dashboardData;
      } catch (parseError) {
        print('Error parsing dashboard data: $parseError'); // Debug log
        rethrow;
      }
    } on DioException catch (e) {
      print('Dio error getting dashboard data: ${e.message}'); // Debug log
      print('Response data: ${e.response?.data}'); // Debug log
      throw _handleError(e);
    } catch (e) {
      print('Error getting dashboard data: $e'); // Debug log
      throw Exception('Failed to get dashboard data: ${e.toString()}');
    }
  }

// Inside ApiService class
  Future<List<CustomerData>> getCustomerList() async {
    try {
      await _checkConnectivity();

      print('Fetching customer list...'); // Debug log

      final response = await _dio.post(ApiConstants.customerList);

      print('Customer List API Response: ${response.data}'); // Debug log

      if (response.data == null) {
        throw Exception('No data received from customer list API');
      }

      final List<dynamic> customerList = response.data['customerData'] ?? [];
      print('Found ${customerList.length} customers in response'); // Debug log

      return customerList.map((json) {
        try {
          return CustomerData.fromJson(json);
        } catch (e) {
          print('Error parsing customer data: $e'); // Debug log
          print('Problematic JSON: $json'); // Debug log
          rethrow;
        }
      }).toList();
    } on DioException catch (e) {
      print('Dio error getting customer list: ${e.message}'); // Debug log
      print('Response data: ${e.response?.data}'); // Debug log
      throw _handleError(e);
    } catch (e) {
      print('Error getting customer list: $e'); // Debug log
      throw Exception('Failed to get customer list: ${e.toString()}');
    }
  }

  Future<List<CustomerData>> getFilteredCustomerList({
    String? productType,
    String? status,
    String? ageing,
  }) async {
    try {
      await _checkConnectivity();

      print('Fetching filtered customer list...'); // Debug log
      print(
          'Filters - Product Type: $productType, Status: $status, Ageing: $ageing'); // Debug log

      final response = await _dio.post(
        ApiConstants.customerListFilter,
        queryParameters: {
          if (productType != null) 'productType': productType,
          if (status != null) 'status': status,
          if (ageing != null) 'ageing': ageing,
        },
      );

      print(
          'Filtered Customer List API Response: ${response.data}'); // Debug log

      if (response.data == null) {
        throw Exception('No data received from filtered customer list API');
      }

      final List<dynamic> customerList = response.data['customerData'] ?? [];
      print(
          'Found ${customerList.length} customers in filtered response'); // Debug log

      return customerList.map((json) {
        try {
          return CustomerData.fromJson(json);
        } catch (e) {
          print('Error parsing filtered customer data: $e'); // Debug log
          print('Problematic JSON: $json'); // Debug log
          rethrow;
        }
      }).toList();
    } on DioException catch (e) {
      print(
          'Dio error getting filtered customer list: ${e.message}'); // Debug log
      print('Response data: ${e.response?.data}'); // Debug log
      throw _handleError(e);
    } catch (e) {
      print('Error getting filtered customer list: $e'); // Debug log
      throw Exception('Failed to get filtered customer list: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getUserAndDocInfo(String userId) async {
    try {
      await _checkConnectivity();

      final response = await _dio.post(
        '${ApiConstants.userAndDocInfo}/$userId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get user and document info');
      }

      final Map<String, dynamic> responseData = response.data;

      // Extract user data
      final userData = responseData['userData'] as Map<String, dynamic>;

      // Initialize empty lists for documents
      List<UserDocument> requiredDocuments = [];
      List<DocumentInfo> documentList = [];
      Map<String, List<DocumentFile>> folderFiles = {};

      // Try to parse required documents if available
      if (responseData.containsKey('userrequiredocumentdata')) {
        final requiredDocsData = responseData['userrequiredocumentdata'];
        if (requiredDocsData is List) {
          requiredDocuments = requiredDocsData
              .map((doc) => UserDocument.fromJson(doc as Map<String, dynamic>))
              .toList();
        }
      }

      // Try to parse document list if available
      if (responseData.containsKey('documentList')) {
        final docListData = responseData['documentList'];
        if (docListData is List) {
          documentList = docListData
              .map((doc) => DocumentInfo.fromJson(doc as Map<String, dynamic>))
              .toList();
        }
      }

      // Try to parse folder files if available
      if (responseData.containsKey('foldersAndFilesData')) {
        final folderData = responseData['foldersAndFilesData'];
        if (folderData is Map) {
          folderFiles = Map.fromEntries(
            folderData.entries.map((entry) {
              final List<DocumentFile> files = [];
              if (entry.value is List) {
                files.addAll(
                  (entry.value as List)
                      .map((file) =>
                          DocumentFile.fromJson(file as Map<String, dynamic>))
                      .toList(),
                );
              }
              return MapEntry(entry.key.toString(), files);
            }),
          );
        }
      }

      return {
        'userLoanInfo': CustomerData.fromJson(userData),
        'requiredDocuments': requiredDocuments,
        'documentList': documentList,
        'folderFiles': folderFiles,
      };
    } on DioException catch (e) {
      print('Dio error getting user and doc info: ${e.message}');
      throw _handleError(e);
    } catch (e) {
      print('Error getting user and doc info: $e');
      throw Exception('Failed to get user and document info: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> tagDocument({
    required String userId,
    required String documentId,
    required String documentType,
    String? rejectReason,
    String? rejectionMessage,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.tagDocument}/$userId/$documentId',
        queryParameters: {
          'documentType': documentType,
          if (rejectReason != null) 'rejectReason': rejectReason,
          if (rejectionMessage != null) 'rejectionMessage': rejectionMessage,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to tag document');
      }

      return response.data;
    } catch (e) {
      print('Error tagging document: $e');
      throw Exception('Failed to tag document: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getProfileBasicInfo() async {
    try {
      final response = await _dio.post(
        ApiConstants.profileBasicInfo,
        options: Options(
          headers: await TokenManager.getAuthHeaders(),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get profile info');
      }

      return response.data;
    } catch (e) {
      print('Error getting profile info: $e');
      throw Exception('Failed to get profile info: ${e.toString()}');
    }
  }

  Exception _handleError(DioException error) {
    print('Handling error: ${error.type}');
    print('Error message: ${error.message}');
    print('Error response: ${error.response?.data}');

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(
            'Request timed out. Please check your internet connection.');

      case DioExceptionType.badResponse:
        final response = error.response;
        if (response?.statusCode == 401) {
          TokenManager.deleteToken();
          return Exception('Session expired. Please login again.');
        }
        return Exception(response?.data?['message'] ??
            'Server error: ${response?.statusCode}');

      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return Exception(
              'No internet connection. Please check your network settings.');
        }
        return Exception('An unexpected error occurred. Please try again.');

      default:
        return Exception('Network error occurred. Please try again.');
    }
  }
}
