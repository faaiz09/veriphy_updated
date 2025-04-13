// lib/models/responses/customer_list_response.dart

import 'package:rm_veriphy/models/customer/customer_data.dart';

class CustomerListResponse {
  final String status;
  final String message;
  final List<CustomerData> customerData;
  final int customerCount;

  CustomerListResponse({
    required this.status,
    required this.message,
    required this.customerData,
    required this.customerCount,
  });

  factory CustomerListResponse.fromJson(Map<String, dynamic> json) {
    return CustomerListResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      customerData: (json['customerData'] as List<dynamic>?)
              ?.map((e) => CustomerData.fromJson(e))
              .toList() ??
          [],
      customerCount:
          int.tryParse(json['customerCount']?.toString() ?? '0') ?? 0,
    );
  }
}
