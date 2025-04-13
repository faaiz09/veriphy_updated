// lib/models/profile/profile_data.dart
class ProfileData {
  final UserBasicInfo user;
  final int activeCustomerCount;
  final String completedCount;
  final String totalProductAmount;

  ProfileData({
    required this.user,
    required this.activeCustomerCount,
    required this.completedCount,
    required this.totalProductAmount,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: UserBasicInfo.fromJson(json['user'] ?? {}),
      activeCustomerCount:
          int.tryParse(json['activeCustomerCount']?.toString() ?? '0') ?? 0,
      completedCount: json['completedCount']?.toString() ?? '0',
      totalProductAmount: json['totalProductAmount']?.toString() ?? '0',
    );
  }
}

class UserBasicInfo {
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
  final String avatar;
  final String status;
  final String? token;
  final String company;
  final String role;
  final List<String> permissions;
  final String? signature;
  final DateTime lastNotification;
  final String? hiddenFiles;
  final String timezone;
  final String language;
  final String initiateStatus;

  UserBasicInfo({
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
    required this.avatar,
    required this.status,
    this.token,
    required this.company,
    required this.role,
    required this.permissions,
    this.signature,
    required this.lastNotification,
    this.hiddenFiles,
    required this.timezone,
    required this.language,
    required this.initiateStatus,
  });

  factory UserBasicInfo.fromJson(Map<String, dynamic> json) {
    return UserBasicInfo(
      id: json['id']?.toString() ?? '',
      firstName: json['fname']?.toString() ?? '',
      lastName: json['lname']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      postalCode: json['postalcode']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      token: json['token']?.toString(),
      company: json['company']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      permissions: _parsePermissions(json['permissions']),
      signature: json['signature']?.toString(),
      lastNotification:
          DateTime.tryParse(json['lastnotification']?.toString() ?? '') ??
              DateTime.now(),
      hiddenFiles: json['hiddenfiles']?.toString(),
      timezone: json['timezone']?.toString() ?? '',
      language: json['lang']?.toString() ?? '',
      initiateStatus: json['initiate_status']?.toString() ?? '',
    );
  }

  static List<String> _parsePermissions(dynamic permissions) {
    if (permissions is String) {
      try {
        // Remove brackets and quotes, then split
        final cleanString = permissions.replaceAll(RegExp(r'[\[\]"]'), '');
        return cleanString
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  String get fullName => '$firstName $lastName';
}
