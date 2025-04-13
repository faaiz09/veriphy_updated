// lib/models/customer/customer_data.dart

class CustomerData {
  final String id;
  final UserDetails userDetails;
  final ProductInfo productInfo;
  final String ageing;
  final int requiredDocuments;
  final int collectedDocuments;
  final int pendingDocuments;
  final String stageState;
  final String? source;
  final String? region;
  final String? ariticId;

  CustomerData({
    required this.id,
    required this.userDetails,
    required this.productInfo,
    required this.ageing,
    required this.requiredDocuments,
    required this.collectedDocuments,
    required this.pendingDocuments,
    required this.stageState,
    this.source,
    this.region,
    this.ariticId,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'] ?? '',
      userDetails: UserDetails.fromJson(json),
      productInfo: ProductInfo.fromJson(json),
      ageing: json['ageing'] ?? '',
      requiredDocuments:
          int.tryParse(json['requireTotalDocuments'] ?? '0') ?? 0,
      collectedDocuments: int.tryParse(json['collectedDocuments'] ?? '0') ?? 0,
      pendingDocuments: int.tryParse(json['pendingDocuments'] ?? '0') ?? 0,
      stageState: json['stage_state'] ?? '',
      source: json['source'],
      region: json['region'],
      ariticId: json['ariticid'],
    );
  }
}

class UserDetails {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String state;
  final String country;
  final String status;
  final String? dob;
  final String? age;
  final DateTime creationDate;
  final DateTime updatedAt;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.state,
    required this.country,
    required this.status,
    this.dob,
    this.age,
    required this.creationDate,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? '',
      firstName: json['fname'] ?? '',
      lastName: json['lname'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postalcode'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      status: json['status'] ?? '',
      dob: json['dob'],
      age: json['age'],
      creationDate:
          DateTime.tryParse(json['creation_date'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }
}

class ProductInfo {
  final String productId;
  final String adminId;
  final String productName;
  final String productType;
  final double productAmount;
  final int productTenure;
  final double eligibilityAmount;
  final double emiAmount;
  final double interestRate;
  final String isSanctionLetterGenerated;
  final String productAnnualPremium;
  final String productProfit;
  final String? channelSource;

  ProductInfo({
    required this.productId,
    required this.adminId,
    required this.productName,
    required this.productType,
    required this.productAmount,
    required this.productTenure,
    required this.eligibilityAmount,
    required this.emiAmount,
    required this.interestRate,
    required this.isSanctionLetterGenerated,
    required this.productAnnualPremium,
    required this.productProfit,
    this.channelSource,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      productId: json['user_product_id'] ?? '',
      adminId: json['admin_id'] ?? '',
      productName: json['product_name'] ?? '',
      productType: json['product_type'] ?? '',
      productAmount:
          double.tryParse(json['product_amount']?.toString() ?? '0') ?? 0.0,
      productTenure:
          int.tryParse(json['product_tenure']?.toString() ?? '0') ?? 0,
      eligibilityAmount:
          double.tryParse(json['eligibility_amount']?.toString() ?? '0') ?? 0.0,
      emiAmount: double.tryParse(json['emiamount']?.toString() ?? '0') ?? 0.0,
      interestRate:
          double.tryParse(json['interest_rate']?.toString() ?? '0') ?? 0.0,
      isSanctionLetterGenerated: json['is_sanction_letter_generates'] ?? '0',
      productAnnualPremium: json['product_annual_premium']?.toString() ?? '0',
      productProfit: json['product_profit'] ?? '',
      channelSource: json['channel_source'],
    );
  }
}
