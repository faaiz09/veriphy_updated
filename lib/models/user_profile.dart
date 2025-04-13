// lib/models/user_profile.dart
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final Map<String, dynamic> stats;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.stats,
  });

  // Sample data factory
  static UserProfile getSampleProfile() {
    return UserProfile(
      id: 'USR001',
      name: 'John Doe',
      email: 'john.doe@rm_veriphy.com',
      role: 'Insurance Agent',
      avatarUrl: '',
      stats: {
        'policiesSold': 45,
        'revenue': 85000,
        'activeClients': 38,
      },
    );
  }
}
